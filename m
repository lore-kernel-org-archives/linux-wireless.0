Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2686 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab2ATPs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 10:48:57 -0500
Received: from mail-sj1-12.sj.broadcom.com (mail-sj1-12.sj.broadcom.com
 [10.17.16.106]) by mail-irva-13.broadcom.com (Postfix) with ESMTP id
 0A367BC396 for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012
 07:48:47 -0800 (PST)
Received: from [10.0.2.15] (unknown [10.177.252.129]) by
 mail-sj1-12.sj.broadcom.com (Postfix) with ESMTP id 76A4C207C0 for
 <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 07:48:46 -0800 (PST)
Message-ID: <4F198CDD.3000202@broadcom.com> (sfid-20120120_164901_602831_6BC45ADE)
Date: Fri, 20 Jan 2012 16:48:45 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pending regulatory request
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon loading the driver for my device I noticed a cfg80211 log about a
'pending regulatory request'. Should I be worried?

Jan 20 16:44:43 lb-bun-09 kernel: [97204.008291] cfg80211: 5735000 KHz -
5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan 20 16:44:43 lb-bun-09 kernel: [97204.012246] ieee80211 phy1:
Selected rate control algorithm 'minstrel_ht'
Jan 20 16:44:43 lb-bun-09 kernel: [97204.014378] cfg80211: Calling CRDA
for country: X0
Jan 20 16:44:43 lb-bun-09 kernel: [97204.014548] brcms_module_init:
register returned 0
Jan 20 16:44:43 lb-bun-09 kernel: [97204.036730] udev[13349]: renamed
network interface wlan0 to wlan3
Jan 20 16:44:43 lb-bun-09 kernel: [97204.055754] ieee80211 phy1:
brcms_ops_bss_info_changed: qos enabled: false (implement)
Jan 20 16:44:43 lb-bun-09 kernel: [97204.055767] ieee80211 phy1:
brcms_ops_config: change power-save mode: false (implement)
Jan 20 16:44:43 lb-bun-09 kernel: [97204.057178] ADDRCONF(NETDEV_UP):
wlan3: link is not ready
Jan 20 16:44:45 lb-bun-09 kernel: [97205.491348] cfg80211: Found new
beacon on frequency: 5745 MHz (Ch 149) on phy1
Jan 20 16:44:45 lb-bun-09 kernel: [97205.491362] cfg80211: Pending
regulatory request, waiting for it to be processed...

