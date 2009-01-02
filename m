Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38832 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZABTct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 14:32:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Kalle Valo" <kalle.valo@iki.fi>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Date: Fri, 2 Jan 2009 20:31:24 +0100
Cc: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>,
	"Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com> <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com> <da94abde0901021106l721ad722w9eb857ed41214377@mail.gmail.com>
In-Reply-To: <da94abde0901021106l721ad722w9eb857ed41214377@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200901022031.24460.mb@bu3sch.de> (sfid-20090102_203252_688628_09D449AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 January 2009 20:06:08 Kalle Valo wrote:
> On Fri, Jan 2, 2009 at 8:52 PM, Stefanik G=E1bor <netrolller.3d@gmail=
=2Ecom> wrote:
> > Probably a NOBTCOEX modparam might be a good idea - when implementi=
ng
> > BT coexistence in b43, a lot of non-BT-aware cards failed to work
> > because the BT GPIO line was connected to the TX preamplifier,
> > breaking all TX.
>=20
> It would be nice to have a common interface for this, for example
> through nl80211. Lots of drivers have BT coexistence support. But thi=
s
> is just an idea.

Well, why? If btcoex works correctly (=3D is not buggy), the user does =
not
notice it at all. I see no reason to turn it off. Except if it's buggy.
But then we should simply fix it or always disable it at compiletime, i=
f
it's not possible to fix.

--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
