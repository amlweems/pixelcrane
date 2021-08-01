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
	"github.com/spf13/cobra"
)

const (
	use   = "pixelcrane"
	short = "pixelcrane is a tool for extracting files from container images"
)

var Root = New(use, short)

// New returns a top-level command for crane. This is mostly exposed
// to share code with gcrane.
func New(use, short string) *cobra.Command {
	root := &cobra.Command{
		Use:               use,
		Short:             short,
		Run:               func(cmd *cobra.Command, _ []string) { cmd.Usage() },
		DisableAutoGenTag: true,
		SilenceUsage:      true,
	}

	commands := []*cobra.Command{
		NewCmdExtract(),
		NewCmdList(),
	}

	root.AddCommand(commands...)

	return root
}
