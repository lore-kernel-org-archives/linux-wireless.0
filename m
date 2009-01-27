Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13821 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZA0SHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 13:07:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 10:07:07 -0800
Date: Tue, 27 Jan 2009 10:06:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christos Zoulas <christos@zoulas.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"file@mx.gw.com" <file@mx.gw.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] file-4.26: add wireless-regdb magic file format
Message-ID: <20090127180625.GM19242@tesla> (sfid-20090127_190712_314062_AE22C1BD)
References: <20090127165416.GJ19242@tesla> <20090127172848.5A6A55654E@rebar.astron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090127172848.5A6A55654E@rebar.astron.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 27, 2009 at 09:28:48AM -0800, Christos Zoulas wrote:
> On Jan 27,  8:54am, lrodriguez@atheros.com ("Luis R. Rodriguez") wrote:
> -- Subject: [PATCH] file-4.26: add wireless-regdb magic file format
> 
> | Christos, this patch adds the wireless-regdb magic file format
> | to the file Magdir. We use this binary file format in Linux for our
> | wireless regulatory database parsed by CRDA. If there are any questions
> | please feel free to puke us on the linux-wireless list.
> |
> | Do you have plans on releasing a file-4.27 any time soon?
> |
> | Thanks to Johannes for coming up with this.
> |
> |   Luis
> |
> | --- /dev/null 2009-01-18 12:51:54.000000000 -0800
> | +++ file-4.26/magic/Magdir/wireless-regdb     2009-01-27 08:40:43.000000000 -0800
> | @@ -0,0 +1,6 @@
> | +# wireless-regdb:        file(1) magic for CRDA wireless-regdb file format
> | +#
> | +# CRDA Regulatory database file
> | +# http://wireless.kernel.org/en/developers/Regulatory
> | +0       belong          0x52474442
> | +>4      belong          19              (Version 1)
> 
> Isn't that belong really:
> 
> 0       string  RGDB    CRDA wireless regulatory database file
> >4      belong  19      (Version 1)

Sure that works as well, makes it nicer too.

  Luis
