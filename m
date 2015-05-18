Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34431 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbERHBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2015 03:01:50 -0400
Received: by qkgx75 with SMTP id x75so103948650qkg.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 00:01:50 -0700 (PDT)
MIME-Version: 1.0
From: darklight wu <darklightwu@gmail.com>
Date: Mon, 18 May 2015 15:01:29 +0800
Message-ID: <CALWn1pu8U1o=J=j8Uunf7-hLNZV2Pv2mxJx11O_psZArij-qNw@mail.gmail.com> (sfid-20150518_090154_084488_8D01E111)
Subject: Failed to capture data packets using Monitor mode with Intel 7260
 card. (Under Ubuntu 14.04)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, All:

I configured the Wifi Monitor mode with Intel 7260 card under
Ubuntu14.04 and then used Wireshark to capture packets from air. But I
could only get management/control packets but no data packets. I tried
different channels and also with HT20 or HT40+/-.

The commands I used were:

iw dev wlan0 interface add mon0 type monitor
iw dev wlan0 del  //I googled and was told I needed to delete the
wlan0 first. Or else I got device busy (-16) error
ifconfig mon0 up
iw dev mon0 set channel 1

I also tried to use other ways like "airmon-ng start wlan0". All the
observations were same, no data packets. It's weird! Anyone has a
clue?

Thanks!
dlw
