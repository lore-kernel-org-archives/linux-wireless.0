Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:48195 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbXJPQOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 12:14:20 -0400
Received: by ug-out-1314.google.com with SMTP id z38so111391ugc
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 09:14:19 -0700 (PDT)
Message-ID: <43e72e890710160914g2caa998cpd7bbb058fd064372@mail.gmail.com> (sfid-20071016_171423_357601_286895C6)
Date: Tue, 16 Oct 2007 12:14:17 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Ath5k compile error in wireless-2.6.git
Cc: "John Daiker" <daikerjohn@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071015234748.GB4125@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <4713EBCA.8010700@gmail.com> <20071015234601.GA4125@tuxdriver.com>
	 <20071015234748.GB4125@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Mon, Oct 15, 2007 at 07:46:01PM -0400, John W. Linville wrote:
> > On Mon, Oct 15, 2007 at 03:38:02PM -0700, John Daiker wrote:
> > > John,
> > >
> > > I just checked out the wireless-2.6.git tree from Kernel.org to test the
> > > new ath5k driver. I get the following compile error on a 'vanilla'
> > > git-clone.
> >
> > Please use the 'everything' branch for development.
> >
> >       git checkout everything

Approach 1

> Hmmm...maybe this instead:
>
>         git checkout -b everything origin/everything

Approach 2

What's fun is that the above is approach 1 is actually necessary on
PowerPC. It seems git for powerpc still uses the old branch stuff. For
example I can't use approach 2. I'll add this to the wiki for ath5k,
just a head up in case there's some PowerPC users out there.

  Luis
