Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:23313 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765389AbYDOQRP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 12:17:15 -0400
Subject: Re: [PATCH 09/12] iwl4965: make iwl4956_send_rxon_assoc
	asynchronous
From: Pavel Roskin <proski@gnu.org>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
	 <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 12:17:12 -0400
Message-Id: <1208276232.14211.28.camel@dv> (sfid-20080415_171721_180111_65DF7B97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-14 at 21:16 -0700, Reinette Chatre wrote:
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   27 ++++++---------------------
>  1 files changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> index 60c0b83..9fb9857 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -758,15 +758,8 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
>  
>  static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)

Wrong patch description.  Please swap 5 and 6 :-)

-- 
Regards,
Pavel Roskin
