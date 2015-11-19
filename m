Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34222 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbbKSD2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 22:28:52 -0500
Received: by qgeb1 with SMTP id b1so43138337qge.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 19:28:52 -0800 (PST)
Date: Wed, 18 Nov 2015 22:28:50 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Antunes <baantunes@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-wireless rebased (probably for the last time) on 4.4-rc1
Message-ID: <20151119032850.GA29270@localhost> (sfid-20151119_042856_310578_8AF0A883)
References: <20151116195551.GD8895@tuxdriver.com>
 <87oaesyb1s.fsf@kamboji.qca.qualcomm.com>
 <CABUTiXU-i7u=1Bbmf=RFfEJM3QYedngxnCr+vVdMPr_pFQ+-tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABUTiXU-i7u=1Bbmf=RFfEJM3QYedngxnCr+vVdMPr_pFQ+-tw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2015 at 11:44:43PM +0000, Bruno Antunes wrote:
> On 17 November 2015 at 14:07, Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > I hope we can find some solution and wireless-testing continues to
> > exist. Otherwise testing latest wireless code will become more
> > difficult.
> 
> Is this tree very difficult to maintain?
> In case there are no volunteers what will be future options for using
> the latest wireless code?

I also tend to use wireless-testing as the main kernel on my laptop, and
find it handy at times to have both recent drivers and mac80211 changes
in the same tree without resorting to backports or merging the trees
myself.  Not much problem doing those, but if I'm going to do it anyway...
might as well share.

So, I'd be willing to help keep it running for a time after said sunset
date.

> says the diagram is out of date, thats obvious, since wireless tree is now
> wireless-drivers and the maintainer is Kalle.
> wireless-drivers ----> net -----> linux
> So what is the process for wireless-testing tree, the merge of linux,
> mac80211and wireless-drivers trees?

mac80211 and wireless-drivers go into net, wireless-testing doesn't
go upstream; it's exactly just for testing.  That said, it's an easy
base to work against since all the bits are reasonably up-to-date.

-- 
Bob Copeland %% http://bobcopeland.com/
