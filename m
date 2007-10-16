Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:15639 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbXJPSF1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 14:05:27 -0400
Received: by wr-out-0506.google.com with SMTP id 36so1130464wra
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 11:05:25 -0700 (PDT)
Message-ID: <43e72e890710161105l4dbd5dc4rc43f241aed42ac92@mail.gmail.com> (sfid-20071016_190542_362478_7E2C6084)
Date: Tue, 16 Oct 2007 14:05:24 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Ath5k compile error in wireless-2.6.git
Cc: "John Daiker" <daikerjohn@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071016170155.GB5677@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4713EBCA.8010700@gmail.com> <20071015234601.GA4125@tuxdriver.com>
	 <20071015234748.GB4125@tuxdriver.com>
	 <43e72e890710160914g2caa998cpd7bbb058fd064372@mail.gmail.com>
	 <20071016170155.GB5677@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Oct 16, 2007 at 12:14:17PM -0400, Luis R. Rodriguez wrote:
> > On 10/15/07, John W. Linville <linville@tuxdriver.com> wrote:
> > > On Mon, Oct 15, 2007 at 07:46:01PM -0400, John W. Linville wrote:
> > > > On Mon, Oct 15, 2007 at 03:38:02PM -0700, John Daiker wrote:
> > > > > John,
> > > > >
> > > > > I just checked out the wireless-2.6.git tree from Kernel.org to test the
> > > > > new ath5k driver. I get the following compile error on a 'vanilla'
> > > > > git-clone.
> > > >
> > > > Please use the 'everything' branch for development.
> > > >
> > > >       git checkout everything
> >
> > Approach 1
> >
> > > Hmmm...maybe this instead:
> > >
> > >         git checkout -b everything origin/everything
> >
> > Approach 2
> >
> > What's fun is that the above is approach 1 is actually necessary on
> > PowerPC. It seems git for powerpc still uses the old branch stuff. For
> > example I can't use approach 2. I'll add this to the wiki for ath5k,
> > just a head up in case there's some PowerPC users out there.
>
> I think this has more to do with the git version (i.e. release) than
> the architecture.  "Approach 1" worked everywhere for a long time,
> while I only became aware of "Approach 2" a few months ago.

On my x86 box I have git 1.5.2.5
On my PPC box have git 1.5.3.4

And no dice on the PowerPC box. Maybe I have to do a new pull with the
new release.. I'll try.

  Luis
