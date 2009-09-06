Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60728 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758108AbZIFSnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 14:43:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: PCMCIA is not experimental anymore
Date: Sun, 6 Sep 2009 20:43:32 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
References: <200909061449.45455.mb@bu3sch.de> <69e28c910909061142g546b4b0aqd123e8d800264505@mail.gmail.com>
In-Reply-To: <69e28c910909061142g546b4b0aqd123e8d800264505@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909062043.33801.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 September 2009 20:42:00 Gábor Stefanik wrote:
> On Sun, Sep 6, 2009 at 2:49 PM, Michael Buesch<mb@bu3sch.de> wrote:
> > PCMCIA support works well and is not experimental anymore.
> >
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >
> > ---
> >  drivers/net/wireless/b43/Kconfig |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > --- wireless-testing.orig/drivers/net/wireless/b43/Kconfig
> > +++ wireless-testing/drivers/net/wireless/b43/Kconfig
> > @@ -42,8 +42,8 @@ config B43_PCICORE_AUTOSELECT
> >        default y
> >
> >  config B43_PCMCIA
> > -       bool "Broadcom 43xx PCMCIA device support (EXPERIMENTAL)"
> > -       depends on B43 && SSB_PCMCIAHOST_POSSIBLE && EXPERIMENTAL
> > +       bool "Broadcom 43xx PCMCIA device support"
> > +       depends on B43 && SSB_PCMCIAHOST_POSSIBLE
> >        select SSB_PCMCIAHOST
> >        ---help---
> >          Broadcom 43xx PCMCIA device support.
> >
> > --
> > Greetings, Michael.
> > _______________________________________________
> > Bcm43xx-dev mailing list
> > Bcm43xx-dev@lists.berlios.de
> > https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> >
> 
> This should be auto-selected depending on SSB_PCMCIAHOST_POSSIBLE (at
> least if !EMBEDDED). There is no need for a separate config prompt if
> it's not EXPERIMENTAL anymore.
> 

Patch please

-- 
Greetings, Michael.
