Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40836 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab3CDWaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 17:30:11 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v4 0/7] mac80211: improve and consolidate minstrel rate control 
Date: Mon,  4 Mar 2013 23:30:00 +0100
Message-Id: <1362436208-75786-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_233014_644182_40D53D12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series merges functions, macros and sampling improvements from
minstrel_ht into minstrel. It adds several improvements to the rate control.

Thomas

v2: remove debugging output (thx to Bob Copeland)
v3: fix array initialization in init_sample_table (thx to Johannes Berg)
v4: fix missing bitmask to access rnd[8] properly (thx to Felix Fietkau)

