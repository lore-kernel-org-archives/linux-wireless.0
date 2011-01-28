Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab1A1QFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:05:55 -0500
Subject: Re: [PATCH 2/8] iwl3945: set STATUS_READY before commit_rxon
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296229671-3041-2-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:04:21 -0800
Message-ID: <1296230661.7388.5.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> Similar change as we already do for agn, need to avoid
> "Error setting Tx power (-5)" message when loading module.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 

good catch, miss that

Wey

