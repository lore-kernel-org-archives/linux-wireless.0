Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702Ab2HMHf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 03:35:26 -0400
Date: Mon, 13 Aug 2012 09:34:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
Message-ID: <20120813073444.GA2272@redhat.com> (sfid-20120813_093529_824992_F71009D8)
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
 <1344426823-1795-7-git-send-email-victorg@ti.com>
 <20120810163635.GC17559@redhat.com>
 <CAK80WHbVcXtZ0on2Nsfkmj+qQ3jAaPLSc9TvGvuaCoN6P4gAOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK80WHbVcXtZ0on2Nsfkmj+qQ3jAaPLSc9TvGvuaCoN6P4gAOQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 12, 2012 at 10:31:29AM +0300, Goldenshtein, Victor wrote:
> > Why we can not use ->channel_switch calback for this purpose (merge
> > ieee80211_channel_switch and ieee80211_ap_ch_switch)?
> >
> 
> Well at first (see previous threads) it was a single channel switch
> for both AP/STA, but later after community reviews it was decided to
> split these two.

Ah, ok. Although I do not see the point of creating almost two identical
structures and two identical callbacks, this is up to Johannes.

Stanislaw
