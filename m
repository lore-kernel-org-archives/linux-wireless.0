Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35056 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1HMIzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 04:55:14 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Qs9zn-0000Ek-Jn
	for linux-wireless@vger.kernel.org; Sat, 13 Aug 2011 10:55:08 +0200
Received: from 69-84-127-230-dhcp.mia.fl.atlanticbb.net ([69.84.127.230])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 10:55:07 +0200
Received: from orlandojperdomo by 69-84-127-230-dhcp.mia.fl.atlanticbb.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 10:55:07 +0200
To: linux-wireless@vger.kernel.org
From: Orlando Perdomo <orlandojperdomo@yahoo.com>
Subject: Re: what dictates the firmware directory of compat-wireless firmware?
Date: Sat, 13 Aug 2011 08:50:30 +0000 (UTC)
Message-ID: <loom.20110813T104536-587@post.gmane.org> (sfid-20110813_105522_423959_60F76541)
References: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com> <BANLkTi=cx1CJkuBgvKkd9tm1u2hu7WGYYA@mail.gmail.com> <BANLkTika=8VetqGXMX7XbsVRM9dBe7AUKA@mail.gmail.com> <BANLkTi=k_HQ2jh5dAeHs5PzWNmUtyhViNQ@mail.gmail.com> <BANLkTikPBuY4Dt=2XSBrR4s5Au-LaWhNiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

George Nychis <gnychis@...> writes:

> 
> > If android hacked udev into the init deamon then you will have to
> > modify the init daemon too but I doubt that they would have kept udev
> > rules statically in the init daemon, so try to find the udev rules.
> >
> 
> I haven't been able to find any other udev rules on the Android
> filesystem.  I have done a ton of digging for any udev information on
> Android, without any luck.  I have asked on the Android mailing list,
> we'll see how that goes.
> 
> In the mean time, the compat_firmware.sh script is pretty straight
> forward.  My process on Android is continually monitoring the USB
> devices connected, I could perform the same actions that
> compat_firmware.sh does to dump the firmware into "/data"
> 
> Thanks for the udev related pointers in compat-wireless!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
I'm having a similar problem with another USB driver to a chipset that requires 
firmware. I have managed to compiler the driver using the compat-wireless method 
for the device but can not figure out where to put the firmware. George from the 
last post it seems you have a work around. Could you elaborate, give more 
details? ...dump firmware into "/data". Thanks



