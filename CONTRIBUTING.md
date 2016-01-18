<!--
Copyright 2015 F5 Networks Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# Contributing Guide for f5-openstack-docs
The f5-openstack-docs repo may be private, but any F5 Networks organization member or partner is welcome to contribute! Please feel free to report issues, make corrections, or contribute material according to the guidelines laid out here.

## Issues
Creating issues is good, creating good issues is even better. Please be specific when opening issues and include:
 
 - the specific file that needs correction
 - line number\(s\) whenever possible

### Feature Requests and Enhancements
Is there something missing or unclear? Please let us know what you'd like to see added to the doc set by opening an issue. Again, please be specific. 

## Pull Requests
If you are submitting a pull request you need to make sure that you have done a few things first.

* If an issue doesn't exist, file one.
* Make sure you have tested your code because we are going to do that when when you make your PR. 
* Clean up your git history because no one wants to see 75 commits for one issue
* Use our [commit template](.git-commit-template.txt)
* Use our pull request template.

```
@<reviewer_id>
#### What issues does this address?
Fixes #<issueid>
WIP #<issueid>
...

#### What's this change do?

#### Where should the reviewer start?

#### Any background context?
```

## Testing
Our Travis CI build will check HTML and verify links when you open a pull request. If your code doesn't pass, please close out your request, fix it, and then open a new request.

## License
 
### Apache V2.0
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 
### Contributor License Agreement
Individuals or business entities who contribute to this project must have completed and submitted the [F5 Contributor License Agreement](http://f5networks.github.io/f5-openstack-docs/cla_landing/index.html) to Openstack_CLA@f5.com prior to their
code submission being included in this project.
