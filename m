Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48127 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993AbYLDT21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 14:28:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2008 11:28:27 -0800
Date: Thu, 4 Dec 2008 11:28:26 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	pat-lkml <pat-lkml@erley.org>,
	Henning Rogge <hrogge@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Looking for a 802.11n card
Message-ID: <20081204192826.GD5970@tesla> (sfid-20081204_202831_542549_E6BCCB9B)
References: <200812032129.16740.hrogge@googlemail.com> <45e8e6c40812031609h50926100xfa616a5bdb9be93e@mail.gmail.com> <49372568.2070404@erley.org> <20081204023512.GU6522@tesla> <69e28c910812040451p231b41e1t63893d23f373bf0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910812040451p231b41e1t63893d23f373bf0c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2008 at 04:51:48AM -0800, Stefanik G=E1bor wrote:
> On Thu, Dec 4, 2008 at 3:35 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > First some alphabet soup for you (this is on the wiki now):
> >
> > HB: PCIe Half MiniCard
> > XB: PCIe Full MiniCard
> > MB: Mini PCI card
> > CB: PCI Cardbus card
> > SB: Single band, 1x1, 1x2, 2x2 configuration
> > DB: Dual band, 2x2 configuration
> >
> > We do have DB HB, HB92/AR9280. HP, Toshiba, Dell, FJ ships with it,=
 and
> > product name is under ath9K site as mentioned above. Also,
> > XB72 (Owl/Fowl, AR5218+AR5133) is dual band XB (see the site).
>=20
> Hennig is looking for a card usable in a desktop (not a laptop). Thes=
e
> are all laptop cards.

This seems to work then:

NEC
<AR5416+AR5133/CB72, 2x3 DB>

    * WL300NC=20

But its not AR9xx, but should do.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
