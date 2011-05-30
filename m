Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1E3VJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 17:09:52 -0400
Received: by eyx24 with SMTP id 24so1461089eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 14:09:51 -0700 (PDT)
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AP mode - usb wlan interface: Sagem XG-76NA 802.11bg
References: <345324.53571.qm@web161601.mail.bf1.yahoo.com>
From: mafeuser@gmail.com
Date: Mon, 30 May 2011 23:09:46 +0200
In-Reply-To: <345324.53571.qm@web161601.mail.bf1.yahoo.com> (Walter Goldens's
	message of "Sun, 29 May 2011 11:40:23 -0700 (PDT)")
Message-ID: <umt4d3izhp45.fsf@gmail.com> (sfid-20110530_230955_898481_2BEFE412)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Walter Goldens <goldenstranger@yahoo.com> writes:

> Hi Paul,
>
> Your device has ZyDAS zd1211b chip which is covered by the zd1211rw driver. Recently AP support has been implemented for this module. You'll likely need compa t-wireless to enable it on your system.
>
> Walter
>

Hallo Walter.

Thank YOu for the answer.

I didn't know about compat-wireless package, thus that's why I upgraded
by ubuntu 10.04 to ubuntu 11.04, then gotten newest kernel 2.6.39 week
ago.

then I did: 
$ iw list
Wiphy phy0
....
....
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP           !!!! YES, YES
		 * AP/VLAN
		 * monitor
		 * mesh point

BUT:(((((:

$ sudo iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

I was a little bit disappointed, that's why I decided to ask You.

What am I doing wrong?

best regards,
Paul

