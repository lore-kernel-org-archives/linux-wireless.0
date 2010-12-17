Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout029.mac.com ([17.148.16.104]:47957 "EHLO
	asmtpout029.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0LQJom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 04:44:42 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp029.mac.com (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep
 26 2008; 64bit)) with ESMTPSA id <0LDK00ERTGE5RQ70@asmtp029.mac.com> for
 linux-wireless@vger.kernel.org; Fri, 17 Dec 2010 01:44:42 -0800 (PST)
Subject: Re: Problem bringing up wlan0 interface up with mainline wl1271 drivers
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
Date: Fri, 17 Dec 2010 13:44:20 +0400
Cc: panduranga <x0125717@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Jara, Pedro" <pedrojara@ti.com>
Message-id: <C4B3622F-ADC4-481E-9340-1819C815184A@mac.com>
References: <57CB308D-7237-46D7-9AF8-7093F52682E8@mac.com>
 <AANLkTikESPwcaxUSDd3B=Oh7kBD-QpndKRHmu9-roDqs@mail.gmail.com>
 <C77CCCD3-2467-4363-A513-05B68B9F57F6@mac.com>
 <E680F3C4CE6F415E95DCBDA48F0158FC@MINX0125717>
 <98BC4735-664C-491E-80CE-356BE32FA2ED@mac.com>
 <AANLkTinejL9LeocQPzjrqrCFYbrF9wqpD9dSyfEVu8us@mail.gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Dec 17, 2010, at 12:51 PM, Arik Nemtsov wrote:

> Ethernet addresses with the LSB of the first octet turned on are considered multicast addresses. Please try:
> 
> ifconfig wlan0 hw ether 00:22:33:44:55:66

That worked, now the only thing is to put the firmware file in the appropriate place, I guess:

# ifconfig wlan0 hw ether 00:22:33:44:55:66

# ifconfig wlan0 up

[  153.843597] wl1271: ERROR could not get firmware: -2

Where should the firmware file be located? /etc/firmware ? 

Elvis Dowson
