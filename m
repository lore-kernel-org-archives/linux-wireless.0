Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:40713 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbaFLIYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 04:24:18 -0400
Date: Thu, 12 Jun 2014 11:24:08 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Linux 3.15: WLAN regression on WRL54GL/B43?
Message-ID: <20140612082408.GD913@drone.musicnaut.iki.fi> (sfid-20140612_102424_185094_98AF4D7F)
References: <20140611230513.GC913@drone.musicnaut.iki.fi>
 <CACna6rwaxzyY+vqQa+vJETA_g+8zLmwWQb9uYhFOvTy57A15rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwaxzyY+vqQa+vJETA_g+8zLmwWQb9uYhFOvTy57A15rw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jun 12, 2014 at 07:44:42AM +0200, Rafał Miłecki wrote:
> On 12 June 2014 01:05, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> > While testing the final 3.15, I noticed that "iwlist wlan0 scanning"
> > cannot find anything on my WRT54GL router anymore:
> 
> I believe it's BCM5352E SoC wth G-PHY rev 7 and radio 0x2050 rev 2. Is
> that correct? Provide us a boot log.

Yes, it's:

[    9.460000] b43-phy0: Broadcom 5352 WLAN found (core revision 9)
[    9.520000] b43-phy0: Found PHY: Analog 2, Type 2 (G), Revision 7

I confirm your patch fixes the issue, thanks.

A.
