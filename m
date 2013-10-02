Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52509 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3JBVPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 17:15:16 -0400
Date: Wed, 2 Oct 2013 14:58:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
Message-ID: <20131002185814.GA2045@tuxdriver.com> (sfid-20131002_231521_000997_9005CA53)
References: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net>
 <1380706904.13329.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380706904.13329.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 02, 2013 at 11:41:44AM +0200, Johannes Berg wrote:
> On Mon, 2013-09-30 at 11:02 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The merge b35c8097 seems to have lost commit eabc4ac5d,
> > put the code back.
> 
> I'm rebasing my tree on -rc1, which actually includes the merge commit,
> so it still makes sense for me to include this commit - I've done that
> now. Sorry for the confusion.

I'm not sure I follow -- please don't base on anything I don't already
have in my tree if you want me to pull from you.

I applied the patch to wireless-next today, FWIW.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
