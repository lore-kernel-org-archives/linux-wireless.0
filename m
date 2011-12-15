Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:43686 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759749Ab1LOXFh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 18:05:37 -0500
Message-ID: <1323990336.18122.1.camel@joe2Laptop> (sfid-20111216_000555_987687_622A94FF)
Subject: Re: [PATCH wireless-next] ath: Convert ath_dbg(bar, ATH_DBG_<FOO>,
 to ath_dbg(bar, FOO
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2011 15:05:36 -0800
In-Reply-To: <CAB=NE6V6AszbNBiMOy4ZacwXqJWeWO0DL3cF_A1E2HVGMicbtA@mail.gmail.com>
References: <1323989753.1270.19.camel@joe2Laptop>
	 <CAB=NE6V6AszbNBiMOy4ZacwXqJWeWO0DL3cF_A1E2HVGMicbtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-15 at 15:00 -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 15, 2011 at 2:55 PM, Joe Perches <joe@perches.com> wrote:
> > Add ATH_DBG_ to macros to shorten the uses and
> > reduce the line count.
> >
> > Coalesce ath_dbg formats.
> > Add missing spaces to coalesced formats.
> > Add missing newline terminations to ath_dbg formats.
> > Align ath_dbg arguments where appropriate.
> > Standardize ath_dbg formats without periods.
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> 
> Good idea, are you cocci spatching this? This will obviosly create
> conflicts with pending patches.

sed/emacs
inspection of formats post sed.

