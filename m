Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2355 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab2KYMX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 07:23:29 -0500
Message-ID: <50B20DAD.9030204@broadcom.com> (sfid-20121125_132333_536624_ADD35FA8)
Date: Sun, 25 Nov 2012 13:23:09 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mips: warning in net/mac80211/tx.c
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I played with crosstool-ng to compile test our driver for a number of
platforms that it is supposed to work on. The gcc version is 4.7.2.

*mips*:
  CC [M]  net/mac80211/tx.o
net/mac80211/tx.c: In function 'ieee80211_subif_start_xmit':
net/mac80211/tx.c:1797:22: error: 'chanctx_conf' may be used
uninitialized in this function [-Werror=maybe-uninitialized]

Gr. AvS

