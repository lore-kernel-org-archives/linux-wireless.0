Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:5297 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbbBPJvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 04:51:25 -0500
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <sp2ong@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 16 Feb 2015 10:51:23 +0100
Date: Mon, 16 Feb 2015 10:51:23 +0100
From: Waldek <sp2ong@wp.pl>
To: linux-wireless@vger.kernel.org
Subject: 10/5 Mhz channel width is possible ?
Message-ID: <54e1bd9b748a00.69475037@wp.pl> (sfid-20150216_105130_571140_90560010)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I have linux kernel version 3.19 and iw tool v3.17. I have use USB WIFI WN722N which use ATH9k_htc driver from kernel
I would like setup channel width 5 MHZ form my ad-hoc Mesh network base on olsrd

I have try setup in following

iw wlan0 set type ibss
ip link set wlan0 up
iw wlan0 ibss join MYNet 2447 5MHZ

but I have message:

command failed: Invalid argument (-22)

when I use 
iw wlan0 ibss join MYNet 2447

no error message but channel width is 20 Mhz

I have see syntax iw tools:

 iw   dev <devname> ibss join <SSID> <freq in MHz> [HT20|HT40+|HT40-|NOHT|5MHZ|10MHZ] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>] [basic-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>] [key d:0:abcde]

it is look that in ibss mode I can set 10 or 5 Mhz width channel but don't work

I have local network which working on OpenWRT with UBNT devices with channel width 5 Mhz
I would like get access to my local network from my laptop with Linux and use USB WIFI WN722N

What is wrong ??

Thank you for help and any suggestion

Waldek






