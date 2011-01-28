Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1A1QQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:16:24 -0500
Date: Fri, 28 Jan 2011 17:16:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Brian Prodoehl <bprodoehl@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
Message-ID: <20110128161612.GC2452@redhat.com>
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
 <AANLkTinhxNK9a6E2iGdFnvQuk-j7W=Pax7WirH08E5eQ@mail.gmail.com>
 <AANLkTikqR=aX+icFSKxkMNCZdbEgPmKR--gAPePgW6vM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTikqR=aX+icFSKxkMNCZdbEgPmKR--gAPePgW6vM@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 06:19:56PM +0100, Rafał Miłecki wrote:
> W dniu 27 stycznia 2011 17:48 użytkownik Brian Prodoehl
> <bprodoehl@gmail.com> napisał:
> > 2011/1/27 Rafał Miłecki <zajec5@gmail.com>:
> >> I've received mini PCIe adapter to PCIe x1 slot to test notebook cards
> >> inserted into PC.  Unfortunately after inserting my Broadcom card to
> >> it, it is not detected in "lspci" at all.
> >>
> >> My WiFi card used to work in "native" slot inside notebook. So if
> >> anything is broken, that would be PCIe x1 slot on motherboard or
> >> adapter itself. I've tested V and GND pins in my PCIe x1 slot, all
> >> work fine. I'll try get some other WiFi cards, to test my adapter
> >> tomorrow.
> >>
> >> However, maybe you have heard about some problems with such a
> >> adapters? Can there be sth preventing my card from being detected,
> >> visible?
> >>
> >> --
> >> Rafał
> >
> > I haven't tested that sort of thing with PCI-Express, but I had bad
> > results with Atheros AR5414-based modules in Mini-PCI to PCI adapters
> > like this:
> >
> > http://www.dealextreme.com/p/mini-pci-to-pci-adapter-with-antenna-9307
> >
> > The system either wouldn't boot, or it would boot and the wireless
> > card wouldn't show up in lspci, so I gave up on it.
> 
> That are not good news :(
> 
> What I've bought is following adapter:
> http://allegro.pl/adapter-wifi-mini-pci-e-na-pci-e-3-anteny-kp13-i1429732145.html

I'm using adapters form http://www.hwtools.net/ , they work pretty well for me,
but they are also quite expensive.

Stanislaw  
