// Copyright 2018 Google LLC All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package cmd

import (
	"fmt"
	"io"
	"os"
	"regexp"

	"github.com/google/go-containerregistry/pkg/crane"
	"github.com/spf13/cobra"

	"github.com/amlweems/pixelcrane/pkg/extract"
)

// NewCmdExtract creates a new cobra.Command for the extract subcommand.
func NewCmdExtract() *cobra.Command {
	return &cobra.Command{
		Use:   "extract IMAGE REGEX",
		Short: "Extract files matching the given regular expression from a remote image as a tarball",
		Example: `  # Extract /etc/passwd from the latest ubuntu image
  pixelcrane extract ubuntu '^etc/passwd$' | tar -xv`,
		Args: cobra.MinimumNArgs(1),
		RunE: func(_ *cobra.Command, args []string) error {
			src := args[0]

			var regexes []*regexp.Regexp
			if len(args) > 1 {
				for _, expr := range args[1:len(args)] {
					regexes = append(regexes, regexp.MustCompile(expr))
				}
			}

			img, err := crane.Pull(src)
			if err != nil {
				return fmt.Errorf("pulling %s: %v", src, err)
			}

			_, err = io.Copy(os.Stdout, extract.Extract(img, func(name string) bool {
				if len(regexes) == 0 {
					return true
				}
				for _, re := range regexes {
					if re.MatchString(name) {
						return true
					}
				}
				return false
			}))
			return err
		},
	}
}
