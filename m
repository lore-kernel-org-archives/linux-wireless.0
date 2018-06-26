Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbeFZPxk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 11:53:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCHv4 0/8] Runtime PM support for wlcore
References: <20180619094342.81831-1-tony@atomide.com>
Date: Tue, 26 Jun 2018 18:53:34 +0300
In-Reply-To: <20180619094342.81831-1-tony@atomide.com> (Tony Lindgren's
        message of "Tue, 19 Jun 2018 02:43:34 -0700")
Message-ID: <87h8lpwnlt.fsf@kamboji.qca.qualcomm.com> (sfid-20180626_175344_432055_7BBF2CB0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> Here's the fourth version of wlcore runtime PM changes. Please
> test one more time.
>
> For testing, please make sure you have also applied patch
> "[PATCHv2] wlcore: sdio: Fix flakey SDIO runtime PM handling"
> to avoid bogus errors.

I assume this is ready to be applied now. If not, please holler.

-- 
Kalle Valo
