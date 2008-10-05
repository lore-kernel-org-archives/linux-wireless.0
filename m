Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42292 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYJEQAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 12:00:39 -0400
Message-ID: <48E8E48E.5090300@openwrt.org> (sfid-20081005_180052_042034_6722267D)
Date: Sun, 05 Oct 2008 18:00:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Derek Smithies <derek@indranet.co.nz>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 0/4] multi-rate retry and the 'minstrel' rate control for
 mac80211
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are the new patches for multi-rate retry and the minstrel 
rate control algorithm (ported from madwifi, mostly rewritten).
I've successfully tested minstrel on ath5k with and without MRR,
but it should be suitable for other drivers as well, as long as
they can set and report the number of tx retries properly.

This series replaces my previous MRR patches.

- Felix
