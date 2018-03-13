Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbeCMPZY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:25:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 06/10] rsi: add module parameter rsi_reg
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
        <1520260620-4694-7-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:25:20 +0200
In-Reply-To: <1520260620-4694-7-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Mon, 5 Mar 2018 20:06:56 +0530")
Message-ID: <874llk0zhb.fsf@purkki.adurom.net> (sfid-20180313_162528_312268_E773B377)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> For few regulatory customizations, we are taking rsi_reg
> as module parameter.

Why?

> +static u16 rsi_reg = RSI_REG_DEF;
> +module_param(rsi_reg, ushort, 0444);
> +MODULE_PARM_DESC(rsi_reg, "0 - RSI_REG_DEF, 1 - RSI_REG_DLCAR");

The documentation tells nothing.

-- 
Kalle Valo
