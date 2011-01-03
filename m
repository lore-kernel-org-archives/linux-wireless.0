Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41265 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1ACKxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 05:53:01 -0500
Received: by qyj19 with SMTP id 19so15729850qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 02:53:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <651997.51284.qm@web31502.mail.mud.yahoo.com>
References: <651997.51284.qm@web31502.mail.mud.yahoo.com>
Date: Mon, 3 Jan 2011 11:48:48 +0100
Message-ID: <AANLkTinBGj6Q1DoGogerhFDMD0ZR1OVYqjSucc-a4oPu@mail.gmail.com>
Subject: Re: Tp-link wn7200nd - cannot associate
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Ming-Ching Tiew <mctiew@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/3 Ming-Ching Tiew <mctiew@yahoo.com>:
>
> I have a TP-LINK WN7200ND, I am tested it with Kernel 2.6.36.1 and 2.6.35.10, basically after inserting the USB, the interface is up and it can never associate with any access point.
>
> #lsmod |grep rt2
>
> rt2800usb               7632  0
> rt2800lib              20328  1 rt2800usb
> rt2x00usb               4628  2 rt2800usb,rt2800lib
> rt2x00lib              15408  2 rt2800lib,rt2x00usb
> mac80211              122068  2 rt2x00usb,rt2x00lib
> cfg80211               92252  2 rt2x00lib,mac80211
>
> There are a lot of similar complaints on the net, this is one example :-
>
> http://ubuntuforums.org/showthread.php?t=1530095
>
> There don't seem to be any issue with 'iwlist wlanX scan'. But just can't associate.
>
> Any recommendation ? Any debug information I should provide ?

Are your networks encrypted? How? What is output of wpa_supplicant? Did you try
nohwcrypt=1
?

-- 
Rafał
