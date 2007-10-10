Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:52252 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbXJJN5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 09:57:54 -0400
Received: by py-out-1112.google.com with SMTP id u77so393719pyb
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 06:57:53 -0700 (PDT)
Message-ID: <40f31dec0710100657g79f7ff22m33f7a2874528d1fb@mail.gmail.com> (sfid-20071010_145759_558596_AB7618DE)
Date: Wed, 10 Oct 2007 16:57:53 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Markus Feldmann" <feldmann_markus@gmx.de>
Subject: Re: Patch for Kernel and Ath5k
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <feil2d$hn2$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <feieb9$nvg$1@sea.gmane.org> <feietp$qf4$1@sea.gmane.org>
	 <40f31dec0710100637w3bfddc67ta32fa244d2cd7343@mail.gmail.com>
	 <feil2d$hn2$1@sea.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/10, Markus Feldmann <feldmann_markus@gmx.de>:
> Nick Kossifidis schrieb:
> > 2007/10/10, Markus Feldmann <feldmann_markus@gmx.de>:
> >> Markus Feldmann schrieb:
> >>> Hi All,
> >>>
> >>> i tried to patch the Kernel to get the ATH5k Driver to work but without
> >>> success.
> >>>
> >>> It seems i miss some scripts like check.sh
> >>>
> >>> Anybody knows how to get my Problem solved?
> >>>
> >>> bye Markus
> >>>
> >> Sorry i forgot to say that i am using the kernel Source 2.6.23-rc8 and
> >> wanna patch this with a Andrew Morton Patch,
> >> 2.6.23-rc8-mm1
> >> 2.6.23-rc8-mm2
> >>
> >> Can anybody write what i have to do?
> >>
> >> I am on Debian Etch. I have got an Atheros Wlan Chip with the ID
> >> 168c:001c (rev 01).
> >>
> >> Thank you and
> >> bye
> >
> > 001c wont work anyway it uses the newer 5.3 EEPROM that we don't yet support ;-(
> >
> >
> No Problem. Is there a need for Debugging? I would send you the debug.
> So maybe in the future it will work.
>

Thanx a lot ! there are some things we need to fix first before we go
for 5424/2424, i'll let you know if there is anything you can do to
help ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
