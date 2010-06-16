Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25687 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab0FPFEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 01:04:30 -0400
Subject: Re: [RFC PATCH] iw: Add support for setting transmit power
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Julian Calaby <julian.calaby@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTilMwuYujJ1vhVGdoop8ZbgHeJRGcWEYECPLcx-B@mail.gmail.com>
References: <1276593467-28309-1-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTilMwuYujJ1vhVGdoop8ZbgHeJRGcWEYECPLcx-B@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 08:04:24 +0300
Message-ID: <1276664664.5277.43000.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 13:50 +0200, ext Julian Calaby wrote:
> On Tue, Jun 15, 2010 at 19:17, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > This patch adds the "set tx_power" command to allow specifying the transmit
> > power level to the WLAN stack. The transmit power configuration consists of
> > a mode (automatic, fixed, limited) and the limit mBm value.
> >
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  Makefile  |    3 ++-
> >  nl80211.h |   27 ++++++++++++++++++++++++++-
> >  2 files changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/Makefile b/Makefile
> > index d303f45..cbb9504 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -17,7 +17,8 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
> >  OBJS = iw.o genl.o event.o info.o phy.o \
> >        interface.o ibss.o station.o survey.o util.o \
> >        mesh.o mpath.o scan.o reg.o version.o \
> > -       reason.o status.o connect.o link.o offch.o ps.o cqm.o
> > +       reason.o status.o connect.o link.o offch.o ps.o cqm.o \
> > +       txpower.o
> >  OBJS += sections.o
> >  ALL = iw
> >
> 
> Call me stupid, but is there a txpower.c?

No I won't call you stupid. It seems I have forgotten to commit again,
but no worries: The corresponding kernel patch went back to the drawing
board, so I'll to redo this patch anyway. I'll be sure also commit
then ;)

-Juuso

> Thanks,
> 


