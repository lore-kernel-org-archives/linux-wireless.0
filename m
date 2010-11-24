Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab0KXPmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 10:42:22 -0500
Subject: Re: [PATCH] iwlwifi: avoid "Error sending TX power (-5)"
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101124141133.GA2983@redhat.com>
References: <1290595069-3878-1-git-send-email-sgruszka@redhat.com>
	 <1290595452.3790.13.camel@jlt3.sipsolutions.net>
	 <20101124130403.GA2446@redhat.com>  <20101124141133.GA2983@redhat.com>
Content-Type: text/plain
Date: Wed, 24 Nov 2010 07:41:20 -0800
Message-Id: <1290613280.28345.6.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2010-11-24 at 06:11 -0800, Stanislaw Gruszka wrote:
> On Wed, Nov 24, 2010 at 02:04:03PM +0100, Stanislaw Gruszka wrote:
> > On Wed, Nov 24, 2010 at 11:44:12AM +0100, Johannes Berg wrote:
> > > On Wed, 2010-11-24 at 11:37 +0100, Stanislaw Gruszka wrote:
> > > > We can have this error message when loading or unloading module, when
> > > > device is not marked as ready, but we want to set tx power from
> > > > commit_rxon. Perhaps something better should be done like call
> > > > lib->send_tx_power() directly from commit_rxon, but for now just
> > > > do not return error.
> > > 
> > > I think this actually fixes it, as opposed to hiding it:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff;h=9e2e7422d059f9b98c3a0810df92a1ff660ade2f
> > 
> > Yes.
> 
> Not fully, message disappears at start, but not when module
> is unloaded.
> 
you are correct, I miss that. Would you like to address that? or I can
fix it

Thanks
Wey

