Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35429 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754574AbcIWEsS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 00:48:18 -0400
Received: by mail-oi0-f54.google.com with SMTP id w11so122328523oia.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2016 21:48:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+PvwyEA-U2OeTrGW+d8B_sEHZYdaM3J79ZcpcC=89MvvYsrCw@mail.gmail.com>
References: <CA+PvwyEA-U2OeTrGW+d8B_sEHZYdaM3J79ZcpcC=89MvvYsrCw@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 23 Sep 2016 06:48:17 +0200
Message-ID: <CACna6rwshvB1xPXwdzpJS7uDz-zWWa=pV29B=0J9JJW+GKUx6g@mail.gmail.com> (sfid-20160923_064822_550477_AC29FF5E)
Subject: Re: Broadcom Firmware Rollback
To: David Petrizze <dpetrizze@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2016 at 04:43, David Petrizze <dpetrizze@gmail.com> wrote:
> I'm having issues with broadcom's latest firmware / driver, version
> 6.30.163.46. Wireless is solid for about a minute, and then drops
> completely. My research has led me to believe my chip (BCM4331) is no
> longer supported under 6.30.X.X, or has a bug somewhere. I want to
> roll back to the firmware that worked.
>
> What I'm looking for is a file named broadcom-wl-6.20.*.*.tar.bz2. I
> found my current firmware from http://www.lwfinger.com/b43-firmware/,
> but 6.20.X.X is nowhere to be found. 5.100.X.X is there, but the 4331
> definitely wasn't supported for that one.
>
> Inside each of these archives on lwfinger is a file called wl_apsta.o,
> where the firmware is extracted from.  Since b43-fwcutter only
> extracts firmware from versions of wl_apsta.o that match specific
> MD5's, I figure 6.20.X.X has to be out there somewhere.
>
> More info can be found from my original post:
> https://bbs.archlinux.org/viewtopic.php?id=3D217326
>
> ...and other people confrim 6.30.X.X being a problem in this ubuntu bug:
> https://bugs.launchpad.net/ubuntu/+source/bcmwl/+bug/1189611
>
> If anyone could point me in the right direction, I would be immensely gra=
teful.

You can't make proprietary driver using firmware of your choice, so
don't bother looking at MIPS drivers stored at Larry's server.

You just need to find a /complete/ (mostly closed source of course)
driver 6.20 for x86/x86_64. I don't think it was ever published on
Broadcom's site, I think it was made available to Ubuntu only under
some agreement. So keep looking at Ubuntu resources.

Also linux-wireless ML focuses on open source drivers, so you may have
more luck asking at Ubuntu community.

--=20
Rafa=C5=82
