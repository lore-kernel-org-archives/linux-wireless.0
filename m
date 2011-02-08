Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1842 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1BHPeP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:34:15 -0500
Subject: Re: [PATCH 3/5] iwlwifi: cleanup iwl_good_ack_health
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297153919-18766-3-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
	 <1297153919-18766-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:32:30 -0800
Message-ID: <1297179150.20613.29.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> Make ack health code easies to read. Compared to previous
> code, we do not print debug messages when expected_ack_cnt_delta == 0
> and also do check against negative deltas.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |   69 ++++++++++++++++----------------
>  1 files changed, 35 insertions(+), 34 deletions(-)
> 

Thank you for cleaning up the code

Wey

