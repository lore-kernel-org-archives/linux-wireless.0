Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45117 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3KYUpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 15:45:15 -0500
Date: Mon, 25 Nov 2013 15:41:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2013-11-19
Message-ID: <20131125204113.GC8228@tuxdriver.com> (sfid-20131125_214533_841809_93BD24E5)
References: <528BCEDB.8010703@gmail.com>
 <529231A4.5010503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <529231A4.5010503@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 24, 2013 at 07:04:36PM +0200, Emmanuel Grumbach wrote:
> 
> 
> On 11/19/2013 10:49 PM, Emmanuel Grumbach wrote:
> > Hi John,
> > 
> > This is a pull request for 3.13.
> > 
> > I have here a few fixes for BT Coex. One of them is a NULL pointer
> > dereference. Another one avoids to enable a feature that can make the
> > firmware unhappy since the firmware isn't ready for it yet. WE also
> > avoid a WARNING that can be triggered upon association in not-so-bad
> > cases even if the association succeeded. We add support for new NICs
> > (not yet on the market) and bump the API so that 3.13 will be able to
> > work with the new firmware that will be out soon hopefully.
> > I also have a boundary check from Johannes.
> > 
> > I reset my tree to wireless/master as the time of this writing. I did
> > that mainly because I needed the changes that were in -next before 3.12
> > went out even if 3.13-rc1 isn't out yet. I plan to rebase my tree on
> > 3.13-rc2 (or 3.13-rc1 if this pull request makes it to 3.13-rc1 but that
> > seems unlikely).
> > Tell me if you have any issues.
> > 
> > 
> 
> FWIW - since 3.13-rc1 is already out and you haven't pulled yet, I
> rebased this pull request --onto v3.13-rc1.

3.13-rc1 is not in the wireless tree (because it isn't in the net
tree).  If it is in your tree, then I can't pull from you -- sorry!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
