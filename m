Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab0CWUpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 16:45:12 -0400
Date: Tue, 23 Mar 2010 16:44:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 00/20] ath9k_hw: ar93xx initial abstraction work
Message-ID: <20100323204401.GA3067@tuxdriver.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com> <43e72e891003171532x5e9893dfmfc1fb469a638d76e@mail.gmail.com> <43e72e891003171550i27531f3bl4e4692494ec36b8@mail.gmail.com> <43e72e891003171853v7458802bgafcf060d75e240a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891003171853v7458802bgafcf060d75e240a7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 06:53:06PM -0700, Luis R. Rodriguez wrote:
> On Wed, Mar 17, 2010 at 3:50 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Mar 17, 2010 at 3:32 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> On Wed, Mar 17, 2010 at 3:27 PM, Luis R. Rodriguez
> >> <lrodriguez@atheros.com> wrote:
> >>> Here's what I have so far, this is rebased on top of Senthil's patches
> >>> for ath9k_htc posted today. Just tested it on my AR9280, it doesn't
> >>> break anything.
> >>
> >> BTW the new ath9k_htc series + this series can be downloaded in one file from:
> >>
> >> http://bombadil.infradead.org/~mcgrof/tmp/all-ar93xx-03-17-v3.patch
> >
> > bleh, I did not use -M here... let me resend with that for the renames.
> 
> On second thought John -- please hold off on merging these new ar93xx
> abstraction patches, we are trying to mathematically prove if ar9002
> register definitions are the same as the ar9003 ones and if so well
> this is all pointless :D

Did this get resolved?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
