Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48920 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZKJAAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 19:00:52 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 9 Nov 2009 16:00:55 -0800
Subject: RE: [PATCH] Libertas: Fix issues while configuring host sleep
Message-ID: <477F20668A386D41ADCC57781B1F704306E249DDDA@SC-VEXCH1.marvell.com>
References: <1257383195-951-1-git-send-email-bzhao@marvell.com>
	<20091106201924.GH2782@tuxdriver.com>
	<477F20668A386D41ADCC57781B1F704306E01F78F3@SC-VEXCH1.marvell.com>
 <87hbt6fvwg.fsf@purkki.valot.fi>
In-Reply-To: <87hbt6fvwg.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> -----Original Message-----
> From: Kalle Valo [mailto:kalle.valo@gmail.com] On Behalf Of Kalle Valo
> Sent: Saturday, November 07, 2009 2:54 AM
> To: Bing Zhao
> Cc: John W. Linville; libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; Amitkumar
> Karwar
> Subject: Re: [PATCH] Libertas: Fix issues while configuring host sleep
> 
> Bing Zhao <bzhao@marvell.com> writes:
> 
> >> The reformatting is a distraction.  It would be better to do just
> >> the fix part separately, especially if you are targetting 2.6.32.
> >
> > Without the reformatting, the change would be like this:
> >
> > +	if (wol->wolopts == 0)    criteria |= EHS_REMOVE_WAKEUP;
> >
> > But the "checkpatch.pl" script gave me an error on that:
> > "ERROR: trailing statements should be on next line"
> 
> You can do the reformatting in the first patch and the second patch
> would contain the actual fix.

I will re-submit as suggested.

Thanks,

Bing

> 
> --
> Kalle Valo
