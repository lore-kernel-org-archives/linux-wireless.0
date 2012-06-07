Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37554 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab2FGKYV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 06:24:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ScZt0-0001Vi-2j
	for linux-wireless@vger.kernel.org; Thu, 07 Jun 2012 12:24:14 +0200
Received: from cph-ex1.sdesigns.com ([192.215.56.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 12:24:14 +0200
Received: from hanskroner by cph-ex1.sdesigns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 12:24:14 +0200
To: linux-wireless@vger.kernel.org
From: Hans =?utf-8?b?S3LDtm5lcg==?= <hanskroner@gmail.com>
Subject: Re: mwifiex:Testing AP functionality with hostapd
Date: Thu, 7 Jun 2012 10:23:57 +0000 (UTC)
Message-ID: <loom.20120607T121239-785@post.gmane.org> (sfid-20120607_122424_746832_10837FE6)
References: <loom.20120607T100950-564@post.gmane.org> <CAJwzM1mTyOv6cUjTQ00-Q-5aW872kwyBPgnH9Pnk82fLZ+-J2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Avinash,

Thanks for your reply!

i)    Firmware version is reported as "mwifiex 1.0 (14.57.5.p69)"

ii)   hostapd version is "v2.0-devel" I took it from git at
      git://w1.fi/srv/git/hostap.git and used the config in my previous post
      to build it. I'm at commit 5b3763336466f2c55611437cb924aeee45f7203e

iii)  Output of hostapd "-ddd" is the same as my previous post, which used
      "-dd". Here it is:

		random: Trying to read entropy from /dev/random
		Configuration file: hostapd-minimal.conf
		nl80211: interface uap0 in phy phy0
		rfkill: initial event: idx=0 type=2 op=0 soft=0 hard=0
		rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
		nl80211: Disable use_monitor with device_ap_sme since no monitor mode
		support detected
		nl80211: Add own interface ifindex 5
		nl80211: Set mode ifindex 5 iftype 3 (AP)
		nl80211: Setup AP - device_ap_sme=1 use_monitor=0
		nl80211: Subscribe to mgmt frames with AP handle 0x74608 (device SME)
		nl80211: Register frame type=0xd0 nl_handle=0x74608
		nl80211: Register frame match - hexdump(len=0): [NULL]
		nl80211: Register frame command failed (type=208): ret=-95 (Operation not
		supported)
		nl80211: Register frame match - hexdump(len=0): [NULL]
		nl80211: Failed to set interface uap0 into AP mode
		netlink: Operstate: linkmode=0, operstate=6
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Try mode change after setting interface down
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Set mode ifindex 5 iftype 2 (STATION)
		nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
		nl80211: Interface mode change to 2 from 3 failed
		nl80211 driver initialization failed.

Thanks for your help!!!

Best Regards,

Hans

