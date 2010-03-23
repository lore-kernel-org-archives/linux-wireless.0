Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15811 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab0CWUxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 16:53:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 13:53:48 -0700
Date: Tue, 23 Mar 2010 13:53:46 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH v2 00/20] ath9k_hw: ar93xx initial abstraction work
Message-ID: <20100323205346.GC3325@tux>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
 <43e72e891003171532x5e9893dfmfc1fb469a638d76e@mail.gmail.com>
 <43e72e891003171550i27531f3bl4e4692494ec36b8@mail.gmail.com>
 <43e72e891003171853v7458802bgafcf060d75e240a7@mail.gmail.com>
 <20100323204401.GA3067@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100323204401.GA3067@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 01:44:01PM -0700, John W. Linville wrote:
> On Wed, Mar 17, 2010 at 06:53:06PM -0700, Luis R. Rodriguez wrote:
> > On Wed, Mar 17, 2010 at 3:50 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> > > On Wed, Mar 17, 2010 at 3:32 PM, Luis R. Rodriguez
> > > <lrodriguez@atheros.com> wrote:
> > >> On Wed, Mar 17, 2010 at 3:27 PM, Luis R. Rodriguez
> > >> <lrodriguez@atheros.com> wrote:
> > >>> Here's what I have so far, this is rebased on top of Senthil's patches
> > >>> for ath9k_htc posted today. Just tested it on my AR9280, it doesn't
> > >>> break anything.
> > >>
> > >> BTW the new ath9k_htc series + this series can be downloaded in one file from:
> > >>
> > >> http://bombadil.infradead.org/~mcgrof/tmp/all-ar93xx-03-17-v3.patch
> > >
> > > bleh, I did not use -M here... let me resend with that for the renames.
> > 
> > On second thought John -- please hold off on merging these new ar93xx
> > abstraction patches, we are trying to mathematically prove if ar9002
> > register definitions are the same as the ar9003 ones and if so well
> > this is all pointless :D
> 
> Did this get resolved?

Yeah but we're just holding off on them for now, we'll send patch bombs
next week I think. But please do take the ath9k_htc stuff.

  Luis
