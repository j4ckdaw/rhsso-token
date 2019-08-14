<h1>rhsso-token</h1>

**Retrieval of Red Hat SSO tokens using user-defined config files**

_Dependencies:_
- yq
- jq

_To install:_

- <code>$ cd rhsso-token</code>
- <code>$ sudo ./install.sh</code>
- <code>$ cd ..</code>
- Optionally, <code>$ rm -r rhsso-token</code>
- Optionally, <code>$ rhsso-token --help</code>

_Getting started:_

- <code>$ rhsso-token -a foo</code>
- <code>$ TOKEN=$(rhsso-token foo)</code>
- You can now use TOKEN in future API calls.

_To uninstall:_

- <code>$ sudo rm /usr/local/bin/rhsso-token</code>
- <code>$ rm -r ~/.rhsso-token/</code>
