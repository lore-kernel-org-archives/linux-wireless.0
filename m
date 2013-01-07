Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46384 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab3AGUhg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 15:37:36 -0500
Message-ID: <50EB3210.3090404@openwrt.org> (sfid-20130107_213743_176184_FDC369BB)
Date: Mon, 07 Jan 2013 21:37:36 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jones Desougi <jones.desougi@27m.se>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Daniel Golle <dgolle@allnet.de>, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: rt2800pci: verify ioremap return value
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org> <50D19F97.9000000@27m.se> <50D1AC1E.7070002@openwrt.org> <20130107200236.GB2203@tuxdriver.com>
In-Reply-To: <20130107200236.GB2203@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.01.07. 21:02 keltezéssel, John W. Linville írta:
> On Wed, Dec 19, 2012 at 12:59:26PM +0100, Gabor Juhos wrote:
> 
>> I will post an updated version of the patch-set anyway and will fix this.
> 
> Is this still coming?

I have posted a modified version of 1/2 as a single patch:

https://patchwork.kernel.org/patch/1918781/

2/2 should be dropped for now.

-Gabor
