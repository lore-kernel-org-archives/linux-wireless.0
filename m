Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41294 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbYKYBAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 20:00:06 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1L4mHa-000894-LK
	for linux-wireless@vger.kernel.org; Tue, 25 Nov 2008 01:00:03 +0000
Received: from 145.10.33.121.broad.gz.gd.dynamic.163data.com.cn ([145.10.33.121.broad.gz.gd.dynamic.163data.com.cn])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 01:00:02 +0000
Received: from doy04 by 145.10.33.121.broad.gz.gd.dynamic.163data.com.cn with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 01:00:02 +0000
To: linux-wireless@vger.kernel.org
From: doyer <doy04@163.com>
Subject: question about MAC80211
Date: Tue, 25 Nov 2008 00:59:01 +0000 (UTC)
Message-ID: <loom.20081125T005048-959@post.gmane.org> (sfid-20081125_020025_284839_70F58D76)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,
i have a question,i need your help.
when i opend the device, the ieee80211_sta_scan_work task will run and send out 
packets,
but it will not work once the device recived packets during scanning,
and the recive interrupt will be captured constantly,the recive handler will 
run into "ieee80211_rx_h_passive_scan" and return "RX_QUEUED",so it will not go 
next never and just return.
i don't known whether the ieee80211_sta_scan_work task is sleepping or been 
cancled.
thanks!


