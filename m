Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41924 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0G0JfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 05:35:24 -0400
Subject: Re: [ath5k-devel] [PATCH v3] ath5k: disable ASPM
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"kernel-team@lists.ubuntu.com" <kernel-team@lists.ubuntu.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	"tim.gardner@canonical.com" <tim.gardner@canonical.com>
In-Reply-To: <20100726225057.GA7268@srcf.ucam.org>
References: <20100726210651.GJ14855@tux>
	 <1280179033.3721.15.camel@maxim-laptop>
	 <20100726212543.GA5424@srcf.ucam.org>
	 <AANLkTi=5_Dc8SumPi7cr8u7=DmnOHgSo6C76w9b0E4Kj@mail.gmail.com>
	 <20100726222113.GA6487@srcf.ucam.org>
	 <AANLkTinq-SxMHTrJM23WaeRMkU-2cySiVrkwCjDRS_o+@mail.gmail.com>
	 <20100726222909.GA6773@srcf.ucam.org>
	 <AANLkTinysGjYS7RKN4X_7T2q+rw_-OWdn-UJYM0poWXu@mail.gmail.com>
	 <20100726223326.GA6904@srcf.ucam.org>
	 <AANLkTinChEx_B9wa-n+a6xDr1vLOBOD3Mhcs=iqcYwen@mail.gmail.com>
	 <20100726225057.GA7268@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:35:13 +0300
Message-ID: <1280223313.3721.83.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 23:50 +0100, Matthew Garrett wrote: 
> On Mon, Jul 26, 2010 at 03:43:04PM -0700, Luis R. Rodriguez wrote:
> 
> > I see.. thanks Mathew... in that case since L1 works on all devices we
> > could just force enable L1 for all PCIE devices. What do you think?
> 
> Works for me.
> 

On the second thought, there is no 'pci_enable_link_state' :-)
I afraid that if I add it, I might not do that right for all cases, thus
do more harm that good...

Best regards,
Maxim Levitsky

