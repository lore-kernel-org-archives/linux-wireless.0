Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51373 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab3I3UpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 16:45:19 -0400
Date: Mon, 30 Sep 2013 16:32:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: fix merge damage
Message-ID: <20130930203206.GM10994@tuxdriver.com> (sfid-20130930_224525_287250_D091F389)
References: <1380531766-15384-1-git-send-email-johannes@sipsolutions.net>
 <1380532074.14467.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380532074.14467.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 30, 2013 at 11:07:54AM +0200, Johannes Berg wrote:
> On Mon, 2013-09-30 at 11:02 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The merge b35c8097 seems to have lost commit eabc4ac5d,
> > put the code back.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Ah, forgot to say - John, I think you should apply this as a patch,
> having it in my pull request seems odd. But if you're of another opinion
> I can stick it into my next -next pull request too.

OK -- does this need to be treated as a fix?  Or is -next OK?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
