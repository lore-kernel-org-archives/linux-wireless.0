Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:31972 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1FBO6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 10:58:11 -0400
Subject: Re: [PATCH 2/2] iwlagn: refactor iwlagn_mac_channel_switch
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110602144619.GB4580@redhat.com>
References: <20110602144424.GA4580@redhat.com>
	 <20110602144619.GB4580@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 07:29:52 -0700
Message-ID: <1307024992.13397.3.camel@wwguy-huron> (sfid-20110602_165815_232256_F8304BB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-02 at 07:46 -0700, Stanislaw Gruszka wrote:
> Use less indentions and remove uneeded irq-save flags.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |  106 ++++++++++++++++----------------
>  1 files changed, 52 insertions(+), 54 deletions(-)
> 


