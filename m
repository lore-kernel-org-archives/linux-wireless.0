Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab1JLOPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 10:15:30 -0400
Subject: Re: [PATCH] iwlagn: fix priv->cfg->ht_params NULL pointer
 dereference
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20111012081634.GA2675@redhat.com>
References: <20111012081634.GA2675@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 06:26:06 -0700
Message-ID: <1318425966.32488.2.camel@wwguy-huron> (sfid-20111012_161533_432097_23FC6675)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 01:16 -0700, Stanislaw Gruszka wrote:
> This fix regression introduced by commit:
> 
> commit 15b3f3b006b42a678523cad989bfd60b76bf4403
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Fri Jun 3 07:54:13 2011 -0700
> 
>     iwlagn: set smps mode after assoc for 1000 device
> 
> Also remove unneeded brackets on the way.
> 
> Address:
> https://bugzilla.redhat.com/show_bug.cgi?id=744155
> 
> If fix will not get 3.1 release, it should be applied in 3.1 stable.
> 
> Cc: stable@kernel.org # 3.1+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
Thanks a lot
Wey

