Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48995 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755042AbcJLO3T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 10:29:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, hofrat@osadl.org,
        xypron.glpk@gmx.de, prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH] rsi: update in vap_capabilities frame to device
References: <1474885981-6810-1-git-send-email-prameela.j04cs@gmail.com>
Date: Wed, 12 Oct 2016 17:29:13 +0300
In-Reply-To: <1474885981-6810-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Mon, 26 Sep 2016 16:03:01
        +0530")
Message-ID: <87k2ddej46.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_162922_500759_E9E81F32)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> added vap status(add/delete) field in vap capabilities frame to device
> added sending vap capabilites frame(with vap status 'delete') in remove interface
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Why? How is this better now? I'm sure there is a good reason why you add
this but we don't know as the commit tells nothing we don't already know
just from looking at the patch.

The most important part of commit log is to answer the question "Why?",
not "What?".

>  		rsi_dbg(ERR_ZONE,
> -			"%s: Interface type %d not supported\n", __func__,
> -			vif->type);
> +			"%s: Interface type %d not supported\n",
> +			__func__, vif->type);

Unnecessary style change, please drop.

> -	rsi_dbg(MGMT_TX_ZONE, "%s: Sending VAP capabilities frame\n", __func__);
> +	rsi_dbg(MGMT_TX_ZONE,
> +		"%s: Sending VAP capabilities frame\n", __func__);

Same here.

-- 
Kalle Valo
