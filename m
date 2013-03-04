Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40280 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757713Ab3CDOWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:22:30 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 0/7] mac80211: improve and consolidate minstrel rate control 
Date: Mon,  4 Mar 2013 15:22:10 +0100
Message-Id: <1362406937-69969-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130304_152242_071195_9D4DE212)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series merges functions, macros and sampling improvements from
minstrel_ht into minstrel. It adds several improvements to the rate control.  

Thomas

