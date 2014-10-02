Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40395 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaJBRpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 13:45:18 -0400
Date: Thu, 2 Oct 2014 13:37:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH 15/16] ath5k: update dependencies
Message-ID: <20141002173746.GB12208@tuxdriver.com> (sfid-20141002_194523_641558_A7D0532B)
References: <1411929195-23775-1-git-send-email-ryazanov.s.a@gmail.com>
 <1411929195-23775-16-git-send-email-ryazanov.s.a@gmail.com>
 <20140930172044.GE11919@tuxdriver.com>
 <CAHNKnsSNO3-mzcKcGdnxEndbq6y_Pr0Gqrv2dMVCZZssgqMnWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHNKnsSNO3-mzcKcGdnxEndbq6y_Pr0Gqrv2dMVCZZssgqMnWA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 01, 2014 at 06:41:34PM +0400, Sergey Ryazanov wrote:
> 2014-09-30 21:20 GMT+04:00 John W. Linville <linville@tuxdriver.com>:
> > This patch does not seem to apply to wireless-next.  What tree is it
> > based upon?
> >
> > John
> >
> Its based on linux-mips. I thought that ath5k was not changed in
> recent time and did not  rebase patch on top of wireless-next.
> 
> John, could you delay patch merging? There is an idea to rename ar231x
> in ath25, to be consistent with ath79 for AR71xx/AR9xxx.

OK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
