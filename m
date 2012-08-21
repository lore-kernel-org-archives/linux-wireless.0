Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41480 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2HUSpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 14:45:17 -0400
Date: Tue, 21 Aug 2012 14:35:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: AceLan Kao <acelan.kao@canonical.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Revert "rfkill: remove dead code"
Message-ID: <20120821183531.GA2733@tuxdriver.com> (sfid-20120821_204521_491250_C27CBB0E)
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
 <CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com>
 <CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com>
 <CAGRGNgX+QmoYhkPuPrr_c5TvqRP=hhzxOSftZh969aOFeiV28g@mail.gmail.com>
 <CAMz9Wg8eMTJcmd5tcxBURP3Rmuu4siEFTBDqW1aK8rqdZ8utqA@mail.gmail.com>
 <20120813184749.GC10529@tuxdriver.com>
 <CAMz9Wg-Ft-STtew-zZ9wSbiC79iEpyV3vp1HoiCutEvn1g=-MA@mail.gmail.com>
 <CAMz9Wg8DdBbWXUv5gQKr6TJmxQqXHn_DEA4UyyuNPzNwsa4Deg@mail.gmail.com>
 <1345458836.4459.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345458836.4459.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2012 at 12:33:56PM +0200, Johannes Berg wrote:
> On Mon, 2012-08-20 at 10:11 +0800, AceLan Kao wrote:
> > Hi,
> > 
> > I didn't see this patch in linux-next nor in Linville's tree,and this
> > patch is needed by the asus-wmi driver.
> > Please help to merge this patch earlier, so that platform-x86 can get
> > rid of the compiling error.
> > Thank you very much.
> 
> I have no objections to this -- should I pick it up, John?

Sure, that sounds great.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
