Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1BIGYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 01:24:17 -0500
Date: Wed, 9 Feb 2011 07:24:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/5] iwlwifi: cleanup {iwl,iwl3945}_good_plcp_health
Message-ID: <20110209062412.GA2184@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
 <1297153919-18766-2-git-send-email-sgruszka@redhat.com>
 <1297178645.20613.28.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297178645.20613.28.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Tue, Feb 08, 2011 at 07:24:05AM -0800, wwguy wrote:
> On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> > Make plcp health code human readable.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-3945.c     |   83 +++++++-----------
> >  drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |  122 +++++++++++----------------
> >  drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
> >  3 files changed, 80 insertions(+), 126 deletions(-)
> > 
> 
> Thanks for the clean up, now is much easier to read.
> 
> Now we are very close to release the split driver, here you change both
> agn and 3945, not sure what is the easier approach will be? push the
> patch now, or wait for the driver split finish, then push the patch
> after that.

I will repost my patches on top of your changes,
hope they'll go to 2.6.39 ?

Stanislaw
