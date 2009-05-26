Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49830 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757986AbZEZXB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 19:01:28 -0400
Message-ID: <4A1C74C1.7060600@gmx.net>
Date: Wed, 27 May 2009 01:01:21 +0200
From: Barkle <barkle@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: RTL 8185
References: <4A199FED.7000609@gmx.net>	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>	 <4A1B00E7.5070801@gmx.net>	 <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>	 <4A1B2186.3070107@gmx.net> <3ace41890905252258p54d858b0qfc172284cb65423f@mail.gmail.com> <4A1C1766.3030004@gmx.net>
In-Reply-To: <4A1C1766.3030004@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barkle schrieb:
> Hin-Tak Leung schrieb:
>> I am asking to a 2nd time - try compat-wireless.
>
> When I compile compat-wireless, I get an error
>
After commenting out in the file "config.mk" the line
#CONFIG_MAC80211_LEDS=y
the code compiles without an error.
Then "make install", reboot and "wpa_supplicant -Dwext -iwlan0
-c/etc/wpa_supplicant/wpa_supplicant.conf -W -dd" => kernel freeze.

What else can I do?
Where can I see which version of the driver are used?


Thanks for helping so long.

