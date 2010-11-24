Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab0KXNE2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 08:04:28 -0500
Date: Wed, 24 Nov 2010 14:04:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: avoid "Error sending TX power (-5)"
Message-ID: <20101124130403.GA2446@redhat.com>
References: <1290595069-3878-1-git-send-email-sgruszka@redhat.com>
 <1290595452.3790.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290595452.3790.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 11:44:12AM +0100, Johannes Berg wrote:
> On Wed, 2010-11-24 at 11:37 +0100, Stanislaw Gruszka wrote:
> > We can have this error message when loading or unloading module, when
> > device is not marked as ready, but we want to set tx power from
> > commit_rxon. Perhaps something better should be done like call
> > lib->send_tx_power() directly from commit_rxon, but for now just
> > do not return error.
> 
> I think this actually fixes it, as opposed to hiding it:
> 
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff;h=9e2e7422d059f9b98c3a0810df92a1ff660ade2f

Yes.

Thanks
Stanislaw 
