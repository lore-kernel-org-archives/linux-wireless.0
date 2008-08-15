Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYHOTnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 15:43:47 -0400
Subject: Re: [RFC] mac80211/cfg80211: Add vif configuration options
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080815193324.GH7998@jm.kir.nu> (sfid-20080815_213419_513780_72D8D6C8)
References: <20080815193324.GH7998@jm.kir.nu>
	 (sfid-20080815_213419_513780_72D8D6C8)
Content-Type: text/plain
Date: Fri, 15 Aug 2008 21:43:44 +0200
Message-Id: <1218829424.3197.2.camel@localhost> (sfid-20080815_214351_795737_38CD6622)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-15 at 22:33 +0300, Jouni Malinen wrote:

> +/**
> + * struct vif_parameters - Virtual interface parameters
> + *
> + * Used to change virtual interface parameters.
> + *
> + * @drop_unencrypted: Whether to drop unencrypted frames
> + *	(0 = no, 1 = yes, -1 = do not change)
> + * @userspace_mlme: Whether to use userspace MLME
> + *	(0 = no, 1 = yes, -1 = do not change)
> + */
> +struct vif_parameters {
> +	int drop_unencrypted;
> +	int userspace_mlme;
> +};

>   * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
>   *
>   * @change_bss: Modify parameters for a given BSS.
> + *
> + * @change_vif: Modify parameters for a given virtual interface.

That reminds me, we should probably include the "bridge packets" thing
in the BSS parameters (or here?)

johannes

