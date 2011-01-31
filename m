Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1AaOz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 09:55:56 -0500
Subject: Re: [PATCH 6/8] iwl3945: do not use agn specific IWL_RATE_COUNT
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296229671-3041-6-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-6-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 06:54:20 -0800
Message-ID: <1296485660.10026.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> Only use IWL_RATE_COUNT_3945 in 3945 code.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |    5 ++---
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    1 +
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
oops, sure

Wey


