Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1AaP3R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:29:17 -0500
Subject: Re: [PATCH] iwlwifi: correct frequency settings
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296475295-5420-1-git-send-email-sgruszka@redhat.com>
References: <1296475295-5420-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 07:27:41 -0800
Message-ID: <1296487661.10026.9.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 04:01 -0800, Stanislaw Gruszka wrote:
> After commit 59eb21a6504731fc16db4cf9463065dd61093e08
> "cfg80211: Extend channel to frequency mapping for 802.11j"
> we use uninitialized sband->band when assign channel frequencies, what
> results that 5GHz channels have erroneous (zero) center_freq value.
> 
> Patch fixes problem and simplifies code a bit.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


Thanks, it make sense.

Wey

