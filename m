Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:36409 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297AbbCMDhA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 23:37:00 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: m.v.b@runbox.com
Subject: [PATCH 00/16] checkpatch clean-up of rtl8723au's rtw_security.c
Date: Thu, 12 Mar 2015 23:15:16 -0400
Message-Id: <1426216532-24058-1-git-send-email-m.v.b@runbox.com> (sfid-20150313_044013_716934_B9307991)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These commits address a number of checkpatch.pl warnings and errors
in rtl8723au's rtw_security.c.

Prior to this set of commits, checkpatch.pl reported the following:
	total: 77 errors, 138 warnings, 1621 lines checked

After applying this set of commits, checkpatch.pl reports the following:
	total: 0 errors, 39 warnings, 1627 lines checked
where the only remaining warnings relate to lines longer than 80
characters and quoted strings split across multiple lines.

There are also a number of commits which improve the code in other ways.
The commit titled "Reorganize a few functions to remove indentation"
reworks two functions to make them more readable.

All of the individual commits have been verified to compile successfully
individually via the use of the interactive rebase feature of git.

M. Vefa Bicakci (16):
  staging: rtl8723au: Reformat whitespace to increase readability
  staging: rtl8723au: Fix "before/around/after" whitespace issues
  staging: rtl8723au: else should follow close brace
  staging: rtl8723au: Fix the indentation of two lines
  staging: rtl8723au: Reorganize a few functions to remove indentation
  staging: rtl8723au: Do not initialize a static to 0
  staging: rtl8723au: else is not generally useful after a return
  staging: rtl8723au: Remove unneeded curly braces
  staging: rtl8723au: trailing statements should be on next line
  staging: rtl8723au: that open brace should be on the previous line
  staging: rtl8723au: No spaces at the start of a line
  staging: rtl8723au: Adjust whitespace in and around comments
  staging: rtl8723au: suspect code indent for conditional statements
  staging: rtl8723au: Improve readability of two very long lines
  staging: rtl8723au: Correct a typo in a trace log line
  staging: rtl8723au: Remove unneeded comments

 drivers/staging/rtl8723au/core/rtw_security.c | 762 +++++++++++++-------------
 1 file changed, 384 insertions(+), 378 deletions(-)

-- 
2.1.4

