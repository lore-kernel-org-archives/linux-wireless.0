Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40145 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaIZRpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 13:45:11 -0400
Date: Fri, 26 Sep 2014 13:35:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-09-21
Message-ID: <20140926173515.GE22967@tuxdriver.com> (sfid-20140926_194517_061371_528DDFC5)
References: <541F23D2.90600@gmail.com>
 <541F251C.8080105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <541F251C.8080105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 21, 2014 at 10:21:00PM +0300, Emmanuel Grumbach wrote:
> 
> 
> On 09/21/2014 10:15 PM, Emmanuel Grumbach wrote:
> > Hi John,
> > 
> > Here is another (last?) pull request for 3.18.
> > 
> > I have here a few things that depend on the latest mac80211's changes: RRM, TPC, Quiet Period etc...
> > Eyal keeps improving our rate control and we have a new device ID. This last patch should probably
> > have gone to wireless.git, but at that stage, I preferred to send it to -next and CC stable.
> > 
> > Let me know if you have issues!
> > 
> > The following changes since commit 6bd2bd27baf12fa0f2e6d611509fc0e1bffb0f97:
> > 
> >   Merge tag 'mac80211-next-for-john-2014-09-12' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next (2014-09-15 14:51:23 -0400)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git master
> > 
> > for you to fetch changes up to 908f324b609320a8839211922f8c4946c891d56c:
> > 
> I had to edit one commit message - new HEAD: 48849a4150e353656dc5d207f2a56ebd00484ce6

I'm pulling this now, but I don't plan to push it back out until
after Dave pulls my earlier pull request...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
