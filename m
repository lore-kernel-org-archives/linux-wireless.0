Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web31507.mail.mud.yahoo.com ([68.142.198.136]:44489 "HELO
	web31507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751004Ab1ADBp1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 20:45:27 -0500
Message-ID: <75410.15386.qm@web31507.mail.mud.yahoo.com>
Date: Mon, 3 Jan 2011 17:45:25 -0800 (PST)
From: Ming-Ching Tiew <mctiew@yahoo.com>
Subject: Re: Tp-link wn7200nd - cannot associate
To: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinBGj6Q1DoGogerhFDMD0ZR1OVYqjSucc-a4oPu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Mon, 1/3/11, Rafał Miłecki <zajec5@gmail.com> wrote:

> >
> > I have a TP-LINK WN7200ND, I am tested it with Kernel
> 2.6.36.1 and 2.6.35.10, basically after inserting the USB,
> the interface is up and it can never associate with any
> access point.
> >
> > #lsmod |grep rt2
> >
> > rt2800usb               7632  0
> > rt2800lib              20328  1 rt2800usb
> > rt2x00usb               4628  2
> rt2800usb,rt2800lib
> > rt2x00lib              15408  2
> rt2800lib,rt2x00usb
> > mac80211              122068  2
> rt2x00usb,rt2x00lib
> > cfg80211               92252  2
> rt2x00lib,mac80211
> >
> > There are a lot of similar complaints on the net, this
> is one example :-
> >
> > http://ubuntuforums.org/showthread.php?t=1530095
> >
> > There don't seem to be any issue with 'iwlist wlanX
> scan'. But just can't associate.
> >
> > Any recommendation ? Any debug information I should
> provide ?
> 
> Are your networks encrypted? How? What is output of
> wpa_supplicant? Did you try
> nohwcrypt=1
> ?
> 

Thanks for the reply. Now I am suspecting that it's the power supply to the usb device. The device is supposed to be 500mW, what do I have to do to check indeed the notebook usb power supply is not enough ?

Regards.


      
