Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:48407 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480Ab0K2M0g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 07:26:36 -0500
Subject: Re: [PATCH] wl12xx: Remove 11j channels from the supported
 channels list.
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: juuso.oikarinen@nokia.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikqg4+ERD6V+7P=2R_H2Q9bWuW3Jz6F=Kp4YKSC@mail.gmail.com>
References: <1291025153-17570-1-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTikqg4+ERD6V+7P=2R_H2Q9bWuW3Jz6F=Kp4YKSC@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 14:26:27 +0200
Message-ID: <1291033587.1673.39.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 13:06 +0100, ext Gábor Stefanik wrote:
> On Mon, Nov 29, 2010 at 11:05 AM,  <juuso.oikarinen@nokia.com> wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> >
> > Because we don't support them at this stage.
> >
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  drivers/net/wireless/wl12xx/main.c |    8 --------
> >  1 files changed, 0 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> > index 7fecefe..dc3a093 100644
> > --- a/drivers/net/wireless/wl12xx/main.c
> > +++ b/drivers/net/wireless/wl12xx/main.c
> > @@ -2374,14 +2374,6 @@ static struct ieee80211_rate wl1271_rates_5ghz[] = {
> >
> >  /* 5 GHz band channels for WL1273 */
> >  static struct ieee80211_channel wl1271_channels_5ghz[] = {
> 
> Is this for WL1271 or WL1273? The comment contradicts the name...

The wl1273 chip supports 5GHz channels.  The wl1271 chip doesn't.

The driver supports both wl1271 and wl1273.  We have even changed the
name to align with this (the driver is now called wl12xx).

We changed the file names and the module names already, but we haven't
changed the function and structure names yet.  At some point someone
will s/wl1271/wl12xx/.  Yes, it is confusing as it is right now, so
hopefully the renaming will happen soon.  Volunteers? ;)

-- 
Cheers,
Luca.

