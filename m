Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422702Ab2KNMiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 07:38:21 -0500
Message-ID: <1352896734.9510.29.camel@jlt4.sipsolutions.net> (sfid-20121114_133823_674033_04ED1842)
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Date: Wed, 14 Nov 2012 13:38:54 +0100
In-Reply-To: <50A38F68.1020506@tieto.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	    <1350226137-13704-2-git-send-email-victorg@ti.com>
	   <1350414099.10177.13.camel@jlt4.sipsolutions.net>
	  <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>
	  <50922A9D.2060409@ti.com> <1352128887.9466.17.camel@jlt4.sipsolutions.net>
	 <50A38F68.1020506@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-14 at 13:32 +0100, Michal Kazior wrote:

> > Hmm. Maybe then the channel should be passed to the radar detection
> > command instead? That way, it can be passed through, you can allocate a
> > channel context, etc. Much easier?
> 
> I was thinking if putting the radar detection parameter in start_ap() is 
> an option (and thus removing the explicit radar cmd)? We could defer 
> `netif_carrier_on()` to be done after the initial radar detection is done.

Yeah, I was actually thinking that too for a bit, not sure if it works
though.

johannes

