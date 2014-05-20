Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38650 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaETOPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 10:15:13 -0400
Date: Tue, 20 May 2014 10:06:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add AUTO-BW rule flag
Message-ID: <20140520140608.GA13981@tuxdriver.com> (sfid-20140520_161518_121844_D78BF4B7)
References: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6X76jCotGR+61wPxyu0treDTebXsxu-inU7xWJnMRLevA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6X76jCotGR+61wPxyu0treDTebXsxu-inU7xWJnMRLevA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 12:59:29AM -0700, Luis R. Rodriguez wrote:
> On Fri, May 9, 2014 at 1:38 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
> > Sync with latest nl80211.h and add AUTO-BW flag.
> > If this flag set, maximum available bandwidth should
> > be calculated base on contiguous rules and wider channels
> > will be allowed to cross multiple contiguous/overlapping
> > frequency ranges.
> >
> > Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> 
> Once John merges this I'll merge on CRDA, just as with the DFS CAC
> patch, please do let me know if and when that happens.

I just merged this yesterday:

commit e90f7a95b9c646b398d56cfe381bf1cc3508d96e
Author: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Date:   Tue Feb 25 08:21:18 2014 +0100

    wireless-regdb: add AUTO-BW rule flag
    
    Sync with latest nl80211.h and add AUTO-BW flag.
    If this flag set, maximum available bandwidth should
    be calculated base on contiguous rules and wider channels
    will be allowed to cross multiple contiguous/overlapping
    frequency ranges.
    
    Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
