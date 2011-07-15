Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:32977 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1GOXee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:34:34 -0400
Received: by fxd18 with SMTP id 18so3452729fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 16:34:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Binary for carl9170
Date: Sat, 16 Jul 2011 01:36:43 +0200
Cc: linux-wireless@vger.kernel.org
References: <CACAiNS3-3K06Cro+VWypyWGetUW-v0qeJ29noXi7WNtUaCWzTw@mail.gmail.com> <20110715151642.0j86tyrj4k0g4sg4-cebfxv@webmail.spamcop.net> <4E20C3DC.3020200@gnu.org>
In-Reply-To: <4E20C3DC.3020200@gnu.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201107160136.44182.chunkeey@googlemail.com> (sfid-20110716_013437_604835_D280F647)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 16 July 2011 00:49:00 Pavel Roskin wrote:
> On 07/15/2011 03:16 PM, Pavel Roskin wrote:
> > Quoting Christian Lamparter <chunkeey@googlemail.com>:
> >> So, since you already have a working version, why simply put it on the
> >> wiki?
> >
> > Yes, I have a working version now (compiled with all defaults) and I'll
> > try to upload it myself.
> 
> Oh well, I can upload it to wiki, but not to your page at 
> http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/
The question is, is kernel.org really a good address to host those firmwares.
especially in a personal folder.

> I don't want to setup an alternative competing repository for carl9170 
> firmwares. Also, it would be nice to have the 1.9.4 firmware on 
> http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/fw/

I would rather have them on wireless.kernel.org. Just like the ath9k_htc
firmware.
> The wiki allows attachments, so I uploaded the firmware as an 
> attachment.  First I put is on the main carl9170 page, but it turned out 
> that MoinMoin doesn't appear to have any way to specify the attachment 
> name in the link.  Since I called the attachment "carl9170-1.fw-1.9.4", 
> it would only download under that name, rather than as "carl9170-1.fw". 
>   I don't want to call the attachment "carl9170-1.fw" since nobody, 
> including me, would be able to replace it with another version ever.
>
> So I created a separate wiki page for the 1.9.4 version of the firmware 
> and attached the firmware to it as "carl9170-1.fw".  That's an 
> equivalent of having directories with files having the same name.
Good thinking, we could add a changelog, the configuration and
some infos like supported features [e.g.: number of supported virtual
interfaces, supported WoWLAN triggers, etc...] to the same page.

> The carl9170 page recommends 1.9.2 for all kernels up to 3.0.  The 1.9.4 
> is recommended for compat-wireless.  If that's not your recommendation, 
> please feel free to update the wiki.
oh no, this should be just fine.

Thanks,
	Christian
