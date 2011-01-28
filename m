Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1A1Qk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:40:26 -0500
Subject: Re: [PATCH 1/8] iwlwifi: do not set tx power when channel is
 changing
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110128162714.GD2452@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296230595.7388.4.camel@wwguy-ubuntu>  <20110128162714.GD2452@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:38:53 -0800
Message-ID: <1296232733.7388.21.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-28 at 08:27 -0800, Stanislaw Gruszka wrote:
> Hi
> 
> On Fri, Jan 28, 2011 at 08:03:15AM -0800, wwguy wrote:
> > On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> > > Mac80211 can request for tx power and channel change in one ->config
> > > call. If that happens, *_send_tx_power functions will try to setup tx
> > > power for old channel, what can be not correct because we already change
> > > the band. I.e  error  "Failed to get channel info for channel 140 [0]",
> > > can be printed frequently when operating in software scanning mode.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > ---
> > 

Wey

