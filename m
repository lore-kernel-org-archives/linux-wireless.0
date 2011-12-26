Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1LZREd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 12:04:33 -0500
Received: by iaeh11 with SMTP id h11so19124337iae.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Dec 2011 09:04:32 -0800 (PST)
Message-ID: <4EF8A91D.5010001@lwfinger.net> (sfid-20111226_180451_868556_854BBC45)
Date: Mon, 26 Dec 2011 11:04:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas <t-om@efn.org>
CC: greg@kroah.com, wireless <linux-wireless@vger.kernel.org>
Subject: Re: looking for Linux firmare/driver for powerbook g4
References: <4EF7BE93.4050001@efn.org>
In-Reply-To: <4EF7BE93.4050001@efn.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/25/2011 06:23 PM, Thomas wrote:
> Hey, thanks for being there!
> I was looking to instal Lubuntu onto my mac powerbook g4 12" (1.5g/1.25ram)
> when I installed ubuntu 10.04 it had a driver available called "broadcom B43"
> for my wi-fi, but on the live cd version of Lubuntu 12.04, I could not even find
> anyway to access additional drivers OR the WLAN (wi-fi) settings or controls,
> etc. and firefox told me I was off line (until I plugged in an ethernet cable)
> I also have a USB wi-fi device that has no branding, but is called:
> WLAN 11n Mini USB Adapter
> FCC ID: WKLWL6203
> mac 0002728E8A88
>
> Is there anything you can do to help me get my old powerbook to use this USB WLAN?
> I'd rather use it (type n) than the internal (g style) "airport extreme"

I have Mint 9 running on my Powerbook G4 Titanium. I bought the machine to debug 
the big-endian issues for driver rtl8192cu. I have a number of USB wireless 
devices, and all work just fine.

Please post the output of the lsusb command so that we know the USB IDs for your 
device. That will determine what driver it needs.

Larry

