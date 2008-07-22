Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tim.rpsys.net ([194.106.48.114]:42586 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYGVMJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 08:09:53 -0400
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry <dbaryshkov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	akpm@linux-foundation.org
In-Reply-To: <bc64b4640807220433i3cfbefbfjac6570c55852c59c@mail.gmail.com>
References: <20080722102159.GA32682@doriath.ww600.siemens.net>
	 <20080722112245.GC15136@khazad-dum.debian.net>
	 <bc64b4640807220433i3cfbefbfjac6570c55852c59c@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 13:09:22 +0100
Message-Id: <1216728562.5421.12.camel@dax.rpnet.com> (sfid-20080722_141003_634558_DE745C32)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-22 at 15:33 +0400, Dmitry wrote:
> 2008/7/22 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> >>  This patch depends on the patch "leds: make sure led->trigger is set
> >>  earlier" which was staged in -mm for some time and recently got merged
> >>  into leds tree.
> >
> > Will it get in mainline for 2.6.27-rc?
> 
> I hope so. It actually depends on Richard Purdie (cc'ed)

That patch is queued and I'll be sending a pull request for the leds and
backlight trees shortly.

Cheers,

Richard

