Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:63127 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932177Ab0CXS1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 14:27:13 -0400
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 00/07] net: remove trailing spaces in messages
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Corey Thomas <coreythomas@charter.net>,
	libertas-dev@lists.infradead.org
From: Frans Pop <elendil@planet.nl>
Date: Wed, 24 Mar 2010 19:27:09 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201003241927.12434.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the third patchset to remove trailing spaces in kernel messages. 
Patches in this set cover wireless code.

Note that the last patch for libertas changes a debugfs header and not 
actually a message.

Patches have been rebased against current net-next.

Benefits are:
- general cleanup and consistency
- minor reduction in kernel size and user's log file size
- reduced annoyance for people writing logcheck rules

Shortstat:
 30 files changed, 124 insertions(+), 124 deletions(-)

Frans Pop (7):
      wireless: remove trailing space in messages
      wireless/ath: remove trailing space in messages
      wireless/ipw2x00: remove trailing space in messages
      wireless/iwlwifi: remove trailing space in messages
      wireless/prism54: remove trailing space in messages
      wireless/raylink: remove trailing space in messages
      wireless/libertas: remove trailing space in debugfs header

Cheers,
FJP
