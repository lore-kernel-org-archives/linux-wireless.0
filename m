Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39301 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaJ1OAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:18 -0400
Date: Tue, 28 Oct 2014 09:48:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2 11/13] ath5k: revert AHB bus support removing
Message-ID: <20141028134859.GB26283@tuxdriver.com> (sfid-20141028_150023_513610_D96424F4)
References: <1413932631-12866-1-git-send-email-ryazanov.s.a@gmail.com>
 <1413932631-12866-12-git-send-email-ryazanov.s.a@gmail.com>
 <20141027180436.GE28300@tuxdriver.com>
 <CAHNKnsTWvZy=-TBv-KPjCOD-vhwcxUUGv61doYUm0F77if-pqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHNKnsTWvZy=-TBv-KPjCOD-vhwcxUUGv61doYUm0F77if-pqw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 11:08:04AM +0400, Sergey Ryazanov wrote:
> 2014-10-27 21:04 GMT+03:00 John W. Linville <linville@tuxdriver.com>:
> > On Wed, Oct 22, 2014 at 03:03:49AM +0400, Sergey Ryazanov wrote:
> >> This reverts commit 093ec3c5337434f40d77c1af06c139da3e5ba6dc.
> >>
> >> AHB bus code has been removed, since we did not have support Atheros
> >> AR231x SoC, required for building the AHB version of ath5k. Now that
> >> support WiSoC chips added we can restore functionality back.
> >>
> >> Singed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> >> Cc: Jiri Slaby <jirislaby@gmail.com>
> >> Cc: Nick Kossifidis <mickflemm@gmail.com>
> >> Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> >> Cc: linux-wireless@vger.kernel.org
> >> Cc: ath5k-devel@lists.ath5k.org
> >
> > Acked-by: John W. Linville <linville@tuxdriver.com>
> >
> John, should I include these two patches in v3 or you already merge
> them in your tree?

I was intending to indicate to Ralf that I'm OK with him merging them
as part of the larger series in his tree.  I have not merged them.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
