Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10221 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZACIqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 03:46:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 00:46:50 -0800
Date: Sat, 3 Jan 2009 14:16:38 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Message-ID: <20090103084637.GA31929@vasanth-laptop> (sfid-20090103_094657_298701_6E641A1C)
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com> <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 03, 2009 at 12:22:49AM +0530, Stefanik G=E1bor wrote:
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
> because the BT GPIO line was connected to the TX preamplifier,
> breaking all TX.

No need for any module parameters for enabling BT coex. It is
already running without any issue on Windows Vista.

Vasanth
>=20
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
