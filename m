Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:34505 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754858Ab3CSNhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 09:37:24 -0400
Date: Tue, 19 Mar 2013 09:30:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: fix size_t printf warnings
Message-ID: <20130319133036.GB2060@tuxdriver.com> (sfid-20130319_143728_102726_2457E073)
References: <20130319132520.30756.84770.stgit@localhost6.localdomain6>
 <87wqt3zfgw.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wqt3zfgw.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 19, 2013 at 03:28:15PM +0200, Kalle Valo wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
> 
> > My new tracing code for ath6kl introduced these warnings on 64-bit:
> >
> > trace.h:38:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 4 has type 'size_t' [-Wformat]
> > trace.h:61:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 4 has type 'size_t' [-Wformat]
> > trace.h:84:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 6 has type 'size_t' [-Wformat]
> > trace.h:119:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 7 has type 'size_t' [-Wformat]
> > trace.h:173:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 3 has type 'size_t' [-Wformat]
> > trace.h:193:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 5 has type 'size_t' [-Wformat]
> > trace.h:221:1: warning: format '%d' expects argument of type 'int',
> > 	but argument 5 has type 'size_t' [-Wformat]
> >
> > Fix them by using %zd.
> >
> > Reported-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> John, can you take this directly so that we can fix the build warnings
> on your tree?

I'll take it, thanks -- may be several hours...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
