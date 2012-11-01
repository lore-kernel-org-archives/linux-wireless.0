Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2KARPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 13:15:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1867018pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2012 10:15:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50922AAF.3060605@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	<1350226137-13704-6-git-send-email-victorg@ti.com>
	<5086371D.2080108@tieto.com>
	<50922AAF.3060605@ti.com>
Date: Thu, 1 Nov 2012 10:15:47 -0700
Message-ID: <CAJ-Vmom5CrnETTCzaf=fw4Unpxh940KCpbh5D=f8PoeTZUXNiA@mail.gmail.com> (sfid-20121101_181602_038613_90FB183E)
Subject: Re: [PATCH v4 5/6] nl80211/cfg80211: add ap channel switch command
From: Adrian Chadd <adrian.chadd@gmail.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"j@w1.fi" <j@w1.fi>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"coelho@ti.com" <coelho@ti.com>, "igalc@ti.com" <igalc@ti.com>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 November 2012 00:54, Victor Goldenshtein <victorg@ti.com> wrote:

> If the driver/device supports MR only on a SC - means it doesn't supports
> channel switch in MR, so basically the radar detection event triggers AP
> channel switch which fails (with this new check) and the AP shut down.
> Of course there are possible driver specific workarounds (as you mentioned
> above) but these are not part of this series.
>
> Just for interest's sake, what is the use case having two APs on the same
> channel?

One interface _just_ doing DFS/spectral/etc, and not hampered by
trying to do TX/RX.



Adrian
