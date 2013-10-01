Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3JAH2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 03:28:50 -0400
Message-ID: <1380612524.14430.0.camel@jlt4.sipsolutions.net> (sfid-20131001_092854_044765_D56882E0)
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 09:28:44 +0200
In-Reply-To: <20130930203206.GM10994@tuxdriver.com>
References: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net>
	 <1380532074.14467.2.camel@jlt4.sipsolutions.net>
	 <20130930203206.GM10994@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 16:32 -0400, John W. Linville wrote:
> On Mon, Sep 30, 2013 at 11:07:54AM +0200, Johannes Berg wrote:
> > On Mon, 2013-09-30 at 11:02 +0200, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > The merge b35c8097 seems to have lost commit eabc4ac5d,
> > > put the code back.
> > > 
> > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > 
> > Ah, forgot to say - John, I think you should apply this as a patch,
> > having it in my pull request seems odd. But if you're of another opinion
> > I can stick it into my next -next pull request too.
> 
> OK -- does this need to be treated as a fix?  Or is -next OK?

I believe the merge damage only occurred during merging wireless.git (or
one of its upstreams) into wireless-next.git.

johannes

