Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0IJFRU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 01:17:20 -0400
Date: Fri, 10 Sep 2010 07:17:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 16/16] iwlwifi: clear is_internal_short_scan when fail to
 initiate scan
Message-ID: <20100910051723.GB2968@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-17-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC4D@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501280FDC4D@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 09, 2010 at 08:35:51AM -0700, Guy, Wey-Yi W wrote:
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index b841016..c3f2957 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -381,14 +381,15 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
>                         internal ? "internal short " : "");
> 
>         set_bit(STATUS_SCANNING, &priv->status);
> -
>         priv->is_internal_short_scan = internal;
> +
> Not needed

Ok. I will merge that patch with patch 2.

Stanislaw
