Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:56060 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0GZWV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 18:21:27 -0400
Date: Mon, 26 Jul 2010 23:21:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"tim.gardner@canonical.com" <tim.gardner@canonical.com>
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
Message-ID: <20100726222113.GA6487@srcf.ucam.org>
References: <1276933774.16697.11.camel@maxim-laptop> <20100619123841.GA31838@hash.localnet> <1276952554.3332.3.camel@maxim-laptop> <1276961564.5173.12.camel@maxim-laptop> <20100726201322.GI14855@tux> <1280177362.3721.7.camel@maxim-laptop> <20100726210651.GJ14855@tux> <1280179033.3721.15.camel@maxim-laptop> <20100726212543.GA5424@srcf.ucam.org> <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 03:15:32PM -0700, Luis R. Rodriguez wrote:
> On Mon, Jul 26, 2010 at 2:25 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > This may need to be done on a chip by chip basis. Take a look at
> > http://www.atheros.cz/inffile.php?inf=68&bit=32&atheros=AR5002G&system=4
> > and some of the other inf files on that site to see which devices
> > provide the PciASPMOptIn flag - those should support ASPM states even if
> > they're pre-1.1 devices.
> 
> I rather we not bother with these, lets simply follow the kernel's
> lead here for its rule matching.

Sorry? The idea is to indicate which chips support ASPM even though 
they're pre-PCIe 1.1. If all Atheros parts work fine with L1 then that 
makes things much easier, but it would be good to know the correct set 
of chips that are broken with L0s.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
