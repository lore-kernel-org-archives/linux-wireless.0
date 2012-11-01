Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938Ab2KATba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 15:31:30 -0400
Message-ID: <1351798320.17469.1.camel@jlt4.sipsolutions.net> (sfid-20121101_203144_522965_C7D4CD89)
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian.chadd@gmail.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>, "nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Date: Thu, 01 Nov 2012 20:32:00 +0100
In-Reply-To: <CAJ-Vmom5CrnETTCzaf=fw4Unpxh940KCpbh5D=f8PoeTZUXNiA@mail.gmail.com> (sfid-20121101_181601_259924_BD2A03DE)
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	 <1350226137-13704-6-git-send-email-victorg@ti.com>
	 <5086371D.2080108@tieto.com> <50922AAF.3060605@ti.com>
	 <CAJ-Vmom5CrnETTCzaf=fw4Unpxh940KCpbh5D=f8PoeTZUXNiA@mail.gmail.com>
	 (sfid-20121101_181601_259924_BD2A03DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-01 at 10:15 -0700, Adrian Chadd wrote:
> On 1 November 2012 00:54, Victor Goldenshtein <victorg@ti.com> wrote:
> 
> > If the driver/device supports MR only on a SC - means it doesn't supports
> > channel switch in MR, so basically the radar detection event triggers AP
> > channel switch which fails (with this new check) and the AP shut down.
> > Of course there are possible driver specific workarounds (as you mentioned
> > above) but these are not part of this series.
> >
> > Just for interest's sake, what is the use case having two APs on the same
> > channel?
> 
> One interface _just_ doing DFS/spectral/etc, and not hampered by
> trying to do TX/RX.

Or maybe just multi-BSSID use cases?!

johannes

