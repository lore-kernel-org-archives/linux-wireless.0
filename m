Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60337 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947AbZABS5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 13:57:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Date: Fri, 2 Jan 2009 19:56:21 +0100
Cc: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com> <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
In-Reply-To: <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200901021956.21785.mb@bu3sch.de> (sfid-20090102_195733_489068_44E7B834)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 January 2009 19:52:49 Stefanik G=E1bor wrote:
> On Fri, Jan 2, 2009 at 11:05 AM, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > ---
> >  drivers/net/wireless/ath9k/ath9k.h |    5 +++++
> >  drivers/net/wireless/ath9k/hw.c    |   33 ++++++++++++++++++++++++=
+++++++++
> >  drivers/net/wireless/ath9k/main.c  |    9 +++++++--
> >  drivers/net/wireless/ath9k/reg.h   |   10 ++++++++++
> >  4 files changed, 55 insertions(+), 2 deletions(-)
> >
> > <snip>
>=20
> Probably a NOBTCOEX modparam might be a good idea - when implementing
> BT coexistence in b43, a lot of non-BT-aware cards failed to work

And what makes you think that atheros also ships cards with broken btco=
ex support?

--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
