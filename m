Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753992AbeEWHyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 03:54:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [EXT] Re: [PATCH V2 3/6] mwifiex: support sysfs initiated device coredump
References: <1526472723-15758-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526472723-15758-4-git-send-email-arend.vanspriel@broadcom.com>
        <87h8n7lnfx.fsf@kamboji.qca.qualcomm.com>
        <5AFC7E01.3070503@broadcom.com>
        <d9414fb243bf4a8daecfef11fe6cdc65@SC-EXCH02.marvell.com>
Date: Wed, 23 May 2018 10:54:05 +0300
In-Reply-To: <d9414fb243bf4a8daecfef11fe6cdc65@SC-EXCH02.marvell.com>
        (Ganapathi Bhat's message of "Mon, 21 May 2018 08:19:35 +0000")
Message-ID: <87po1mu7s2.fsf@purkki.adurom.net> (sfid-20180523_095441_544438_73EBAA49)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> In V2:
>
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(mwifiex_send_cmd);
>
> Instead of exporting 'mwifiex_send_cmd' we can prepare a wrapper for
> the command 'MWIFIEX_IFACE_WORK_DEVICE_DUMP' in mwifiex module. Let me
> know if we can send a follow up.

So what's the plan? Can I apply this patch or should I drop it?

-- 
Kalle Valo
