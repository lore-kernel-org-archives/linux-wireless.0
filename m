Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab1BGKMl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 05:12:41 -0500
Date: Mon, 7 Feb 2011 11:11:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Don Fry <donald.h.fry@intel.com>
Subject: Re: [PATCH wireless-2.6.38] iwlagn: Re-enable RF_KILL interrupt when
 down
Message-ID: <20110207101123.GA2319@redhat.com>
References: <1297013385-9918-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297013385-9918-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 09:29:45AM -0800, Wey-Yi Guy wrote:
> From: Don Fry <donald.h.fry@intel.com>
> 
> With commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 only one RF_KILL
> interrupt will be seen by the driver when the interface is down.
> 
> Re-enable the interrupt when it occurs to see all transitions.

What practical problem this fix? I'm asking, because my RF_KILL commit
went to stable, shouldn't this fix go to stable as well?

Stanislaw
