Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aktaia.intevation.org ([212.95.126.10]:56208 "EHLO
	kolab.intevation.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751474AbYFTHfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 03:35:47 -0400
From: Bernhard Reiter <bernhard@intevation.de>
To: linux-wireless@vger.kernel.org, Dave <kilroyd@googlemail.com>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
Date: Fri, 20 Jun 2008 09:35:54 +0200
References: <200806181715.20516.bernhard@intevation.de> <200806191023.39851.bernhard@intevation.de> <485A9A00.70700@gmail.com>
In-Reply-To: <485A9A00.70700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200806200935.55882.bernhard@intevation.de> (sfid-20080620_093552_914374_FDD213DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Am Donnerstag, 19. Juni 2008 19:40:16 schrieb Dave:
> Bernhard Reiter wrote:
> > Ah, I never found that one. Also because the match that this indeed
> > is a HermesII card could never be made for sure by myself
> > and because that page is only about Hermes I.
> >
> > So this is the first indication that the wlags_h2_718 might work
> > for the Hermes II card. Where can I download it without registratio=
n?
> > Why wasn't the 7.22 version used as base for the patch?
>
> The 7.18 Agere driver supports both Hermes I and Hermes II based card=
s. The
> 7.22 driver removed support for Hermes I, hence people have concentra=
ted on
> the 7.18 version.

okay, this is understandable.

> Both versions can be found at <http://www.xs4all.nl/~pptp/agere>, whi=
ch
> also has patched versions for 2.6

Cool!
Just to make sure: This is a driver that - despite being unmaintained -=
 should=20
work? So could try it with 2.6.17, 2.6.24 and even newer?

adTHANKSvance,
Bernhard
[List, please cc me on relevant replies.]

--=20
Managing Director - Owner: www.intevation.net       (Free Software Comp=
any)
Germany Coordinator: fsfeurope.org. Coordinator: www.Kolab-Konsortium.c=
om.
Intevation GmbH, Osnabr=FCck, DE; Amtsgericht Osnabr=FCck, HRB 18998
Gesch=E4ftsf=FChrer Frank Koormann, Bernhard Reiter, Dr. Jan-Oliver Wag=
ner
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
