Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47359 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933617AbZGPXuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:50:22 -0400
Date: Fri, 17 Jul 2009 02:50:13 +0300
From: Jouni Malinen <j@w1.fi>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: PCI express card that does AP mode? (abit wlp-01?)
Message-ID: <20090716235013.GA26789@jm.kir.nu>
References: <wfljmpm4xl.fsf@calligramme.charmers> <43e72e890907160914gdaa700amb2394d8b859d95cb@mail.gmail.com> <wf63dsmvjg.fsf@calligramme.charmers>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wf63dsmvjg.fsf@calligramme.charmers>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 05:39:47PM +0100, Jon Fairbairn wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com>
> writes:
> > http://wireless.kernel.org/en/users/Drivers/ath9k

> Thanks, but I've seen that page and "products with supported ath9k
> cards" points to a page that lists "Laptops with ath9k cards" (I'm
> looking for PCIe, not mini-PCIe) and "APs with ath9k cards", not "ath9k
> cards". Before I can buy a card, I need to know what it is called in the
> shops (on-line or otherwise), not what chipset it has.

I don't know how the product list ended up being split that way, but the
"laptops" page does actually include number of D-Link adapters,
including a PCIe desktop adapter (D-Link DWA-556) that seems to match
the request. I saw it at Fry's last week and it does indeed look like a
PCIe card. It is not exactly the least expensive option and is not the
latest 11n MAC revision, but at least it is available and I would expect
it to work with ath9k in AP mode.

> I realise this is the manufacturer's fault, but this is a perennial
> problem for Linux users who want to buy an new card for something: "OK,
> I want something with such-and-such a chipset, but the on-line shops
> just don't say what the chipset is.

Combination of model number (and revision in some cases! urgh) and
driver download and/or FCCID lookup can help with that, but yes, this is
quite painful in many cases. However, I've also seen some cards that
have the box actually listing both the chipset vendor (even both MAC and
PHY model number) and Linux support, so there is some hope in figuring
this out even at a store without having to do an internet lookup..

-- 
Jouni Malinen                                            PGP id EFC895FA
