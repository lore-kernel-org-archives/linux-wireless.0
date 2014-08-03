Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward19.mail.yandex.net ([95.108.253.144]:46020 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaHCLdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2014 07:33:19 -0400
Received: from web18g.yandex.ru (web18g.yandex.ru [95.108.252.118])
	by forward19.mail.yandex.net (Yandex) with ESMTP id 81BE9112146D
	for <linux-wireless@vger.kernel.org>; Sun,  3 Aug 2014 15:25:56 +0400 (MSK)
From: =?koi8-r?B?4c7E0sXF1yDzxdLHxco=?= <flat343@yandex.ru>
To: linux-wireless@vger.kernel.org
Subject: Problem with wpasupplicant using nl80211 driver for wi-fi stick with REALTEK 8188 chipset
MIME-Version: 1.0
Message-Id: <6570401407065155@web18g.yandex.ru> (sfid-20140803_133333_456419_941BB6E9)
Date: Sun, 03 Aug 2014 15:25:55 +0400
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
A lot of folks experience problems with wpa_supplicant using nl80211 driver - tha does not work. 
The particular problem is experienced on raspberry pi with wi-fi adapter on Realtek 8188 chipset. 
The syslog shows the following lines:
 wpa_supplicant[1118]: nl80211: 'nl80211' generic netlink not found
 raspbmc wpa_supplicant[1118]: Failed to initialize driver 'nl80211'
 raspbmc wpa_supplicant[1118]: rfkill: Cannot open RFKILL control device

I have tired to modify /etc/wpa_suppicant/functions.sh and remove nl80211 completely from code and leave only wext driver but that does not work. 
Would appreciate any ideas what the problem could be.

OS version: raspbian 3.12.21 

WPA supplicant version: 1.0-3

Thank you for the support.
Sergei. 
