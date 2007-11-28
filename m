Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:16412 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXK1HYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 02:24:40 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-jgarzik' branch of wireless-2.6
Date: Wed, 28 Nov 2007 08:25:14 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
References: <20071127144748.GA12408@tuxdriver.com> <200711271708.54801.hs4233@mail.mn-solutions.de> <1196179975.5194.7.camel@localhost.localdomain>
In-Reply-To: <1196179975.5194.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711280825.14339.hs4233@mail.mn-solutions.de> (sfid-20071128_072443_368983_39EAAF58)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But then again it's dealing with hardware bits.  I do have an
> 8385 CF card on the way though.

Ah, that explains your question in #libertas on freenode.org:

  [23:15] <dcbw> schurig: what CF parts are you using, off the shelf ones or the Ambicom WL54-CF or something?

The WLAN card that I have is unmarked. Is has a blue label on it
says just

   WLAN CF Card
    802.11b/g

and on the back side is just a MAC address. No FCC number, no
nothing. I guess it was an engeneering sample. However, the MAC
address begins with 00:16:41 and according to

  http://standards.ieee.org/regauth/oui/index.shtml

this is therefore an USI card, or manufactured by them.
