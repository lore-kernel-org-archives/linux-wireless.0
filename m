Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3448 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933863AbXJPRip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 13:38:45 -0400
Date: Tue, 16 Oct 2007 13:01:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Daiker <daikerjohn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Ath5k compile error in wireless-2.6.git
Message-ID: <20071016170155.GB5677@tuxdriver.com> (sfid-20071016_183913_116269_D57D1C15)
References: <4713EBCA.8010700@gmail.com> <20071015234601.GA4125@tuxdriver.com> <20071015234748.GB4125@tuxdriver.com> <43e72e890710160914g2caa998cpd7bbb058fd064372@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890710160914g2caa998cpd7bbb058fd064372@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 16, 2007 at 12:14:17PM -0400, Luis R. Rodriguez wrote:
> On 10/15/07, John W. Linville <linville@tuxdriver.com> wrote:
> > On Mon, Oct 15, 2007 at 07:46:01PM -0400, John W. Linville wrote:
> > > On Mon, Oct 15, 2007 at 03:38:02PM -0700, John Daiker wrote:
> > > > John,
> > > >
> > > > I just checked out the wireless-2.6.git tree from Kernel.org to test the
> > > > new ath5k driver. I get the following compile error on a 'vanilla'
> > > > git-clone.
> > >
> > > Please use the 'everything' branch for development.
> > >
> > >       git checkout everything
> 
> Approach 1
> 
> > Hmmm...maybe this instead:
> >
> >         git checkout -b everything origin/everything
> 
> Approach 2
> 
> What's fun is that the above is approach 1 is actually necessary on
> PowerPC. It seems git for powerpc still uses the old branch stuff. For
> example I can't use approach 2. I'll add this to the wiki for ath5k,
> just a head up in case there's some PowerPC users out there.

I think this has more to do with the git version (i.e. release) than
the architecture.  "Approach 1" worked everywhere for a long time,
while I only became aware of "Approach 2" a few months ago.

John
-- 
John W. Linville
linville@tuxdriver.com
