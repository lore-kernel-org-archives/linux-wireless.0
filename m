Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39231 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011AbYEQWfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 18:35:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Add hooks for firmware debugging
Date: Sun, 18 May 2008 00:35:04 +0200
Cc: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
References: <200805172244.35966.mb@bu3sch.de> <200805172324.13818.mb@bu3sch.de> <69e28c910805171527y4521a9e7n34d1842281234769@mail.gmail.com>
In-Reply-To: <69e28c910805171527y4521a9e7n34d1842281234769@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200805180035.04341.mb@bu3sch.de> (sfid-20080518_003610_436033_D294F816)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 May 2008 00:27:49 Stefanik G=E1bor wrote:
> On Sat, May 17, 2008 at 11:24 PM, Michael Buesch <mb@bu3sch.de> wrote=
:
> > On Saturday 17 May 2008 23:21:22 Stefanik G=E1bor wrote:
> >> Hmm... what's this? Are we planning something along the lines of
> >> prism54's FreeMAC?
> >
> > http://bu3sch.de/gitweb?p=3Db43-ucode.git;a=3Dsummary
> >
> > Doesn't work, yet. So you don't need to try. ;)
> >
> > --
> > Greetings Michael.
> >
>=20
> Hmm, are we calling this "Broadcom BCM43xx Microcode" instead of
> "Broadcom AirForce One Microcode" for licensing/trademark reasons? Th=
e
> official name of these cards is AirForce One.

That's the first time I hear that, so it's most likely not _that_ offic=
ial. ;)

And quite honestly, I don't care at all playing bullshit-bingo with buz=
zwords.
The device has the product number 43XX, so we identify it that way.

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
