Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1A1QOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:14:42 -0500
Subject: Re: [PATCH 4/8] iwlwifi: introduce iwl_advanced_bt_coexist()
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296229671-3041-4-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:13:08 -0800
Message-ID: <1296231188.7388.13.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> We use priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist
> conditional in few places, merge it into one function.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.h    |    6 ++++++
>  drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-power.c   |    6 ++----
>  drivers/net/wireless/iwlwifi/iwl-scan.c    |    3 +--
>  4 files changed, 10 insertions(+), 7 deletions(-)

Wey

 

