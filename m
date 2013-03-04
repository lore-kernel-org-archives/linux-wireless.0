Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40601 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758416Ab3CDSsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:48:35 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v3 0/7] mac80211: improve and consolidate minstrel rate control 
Date: Mon,  4 Mar 2013 19:48:17 +0100
Message-Id: <1362422905-78079-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_194839_850450_A0D1D177)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series merges functions, macros and sampling improvements from
minstrel_ht into minstrel. It adds several improvements to the rate control.

Thomas

v2: remove debugging output (thx to Bob Copeland)
v3: fix array initialization in init_sample_table (thx to Johannes Berg)

