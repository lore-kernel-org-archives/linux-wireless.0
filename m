Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52775 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1GSVRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 17:17:09 -0400
Date: Tue, 19 Jul 2011 17:09:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH 2/4] bcma: allow setting FAST clockmode for a core
Message-ID: <20110719210913.GD2477@tuxdriver.com> (sfid-20110719_231713_348964_D8D53EC4)
References: <1310857566-2876-1-git-send-email-zajec5@gmail.com>
 <1310857566-2876-2-git-send-email-zajec5@gmail.com>
 <20110719204246.GB2477@tuxdriver.com>
 <CACna6rxZMFnFiYFkrW9xTkL_eXTXH91sEO-W=HZqoiUYLMNumQ@mail.gmail.com>
 <CACna6rwCNyOKN+gHESX6Qt7uKQNuPWBrsyTJ1rWzjXMULV5y6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwCNyOKN+gHESX6Qt7uKQNuPWBrsyTJ1rWzjXMULV5y6Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2011 at 10:54:32PM +0200, Rafał Miłecki wrote:
> W dniu 19 lipca 2011 22:50 użytkownik Rafał Miłecki <zajec5@gmail.com> napisał:
> > W dniu 19 lipca 2011 22:42 użytkownik John W. Linville
> > <linville@tuxdriver.com> napisał:
> >>  CC [M]  drivers/bcma/core.o
> >> drivers/bcma/core.c: In function ‘bcma_core_set_clockmode’:
> >> drivers/bcma/core.c:65:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
> >> drivers/bcma/core.c:65:22: note: each undeclared identifier is reported only once for each function it appears in
> >> drivers/bcma/core.c:65:73: error: ‘BCMA_CLKCTLST_FORCEHT’ undeclared (first use in this function)
> >> drivers/bcma/core.c:69:8: error: ‘BCMA_CLKCTLST_HAVEHT’ undeclared (first use in this function)
> >> drivers/bcma/core.c: In function ‘bcma_core_pll_ctl’:
> >> drivers/bcma/core.c:89:35: error: ‘BCMA_CLKCTLST_EXTRESREQ’ undeclared (first use in this function)
> >> drivers/bcma/core.c:90:38: error: ‘BCMA_CLKCTLST_EXTRESST’ undeclared (first use in this function)
> >> drivers/bcma/core.c:93:22: error: ‘BCMA_CLKCTLST’ undeclared (first use in this function)
> >> make[2]: *** [drivers/bcma/core.o] Error 1
> >> make[1]: *** [drivers/bcma] Error 2
> >> make: *** [drivers] Error 2
> >
> > I'm sorry, that's quite normal you could lost order&dependency with
> > the amount of patches I've sent.
> >
> > As nobody objected, please apply
> > [RFC][PATCH] bcma: move define of BCMA_CLKCTLST register
> > It should be applied before this one.
> 
> Could I do something to avoid such a problems in the future?
> 
> Should I put info about dependency in cover-letter? Should I create
> own git tree? Should I slow down with sending patches (doing more of
> them before sending)?

It is always good to indicate dependencies, especially on patches
posted in a different series or when the dependency is on a patch
posted as RFC.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
