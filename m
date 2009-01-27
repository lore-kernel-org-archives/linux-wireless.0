Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10190 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbZA0POI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 10:14:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 07:14:08 -0800
Date: Tue, 27 Jan 2009 07:13:26 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bharat Bhushan <bharat.b.bhushan@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 802.11k support in open source mac
Message-ID: <20090127151326.GH19242@tesla> (sfid-20090127_161414_950906_5F27D07F)
References: <d9360e520901270334p332b09e9sefbf1f861ecbe907@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <d9360e520901270334p332b09e9sefbf1f861ecbe907@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 27, 2009 at 03:34:57AM -0800, Bharat Bhushan wrote:
> hi
> 
>           Do open source mac support 802.11 K in main line kernel
> source tree ? further does any one working on it ?
> 
> Thanks in anticipation

IIRC last I looked into this it seemd 802.11k is more of a device
requirement on affinity for reporting signal amongst other things.
At least for signal we already try to report stuff in dBm when we can,
the resolution guarantee would be up to the device. It should be
relatively easily to do the conversion to the 11k range but not
sure which devices are capable of ensuring the affinity at the moment.

I'm sure there is more to 11k than just signal measurement, what else
was on it that you are interested? Too lazy to check right now.

  Luis
