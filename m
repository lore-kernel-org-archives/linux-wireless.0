Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39275 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYKHKDu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 05:03:50 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA8A3dFm016823
	for <linux-wireless@vger.kernel.org>; Sat, 8 Nov 2008 04:03:48 -0600
Received: from tikku (essapo-nirac252165.europe.nokia.com [10.162.252.165])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA8A3j5P029897
	for <linux-wireless@vger.kernel.org>; Sat, 8 Nov 2008 12:03:45 +0200
To: linux-wireless@vger.kernel.org
Subject: iwconfig power timeout
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 08 Nov 2008 12:03:44 +0200
Message-ID: <87tzaiwn3z.fsf@nokia.com> (sfid-20081108_110355_356167_0D74E561)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to set power save timeout for mac80211 with iwconfig, but
I'm having problems with iwconfig on Nokia N810:

Nokia-N810-35-3:~# iwconfig wlan0 power timeout 500m
Error for wireless request "Set Power Management" (8B2C) :
    invalid argument "500m".
Nokia-N810-35-3:~# iwconfig wlan0 power timeout 3
Error for wireless request "Set Power Management" (8B2C) :
    invalid argument "3".
Nokia-N810-35-3:~# 

Looking at iwconfig sources the error means that either my syntax is
wrong or iwconfig has a bug in the parser. I'm guessing the latter
based on reading iwconfig(5). But before I will start investigating
iwconfig's magic, has anyone else seen this?

I'm using wireless-tools 29~pre21-2.osso1 on my N810, but I see a
similar error with wireless-tools 29-1.1 on my laptop running debian
unstable.

-- 
Kalle Valo
