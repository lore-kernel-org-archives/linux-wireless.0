Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932581AbeF1JTZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:19:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [5/8] wclore: Fix timout errors after recovery
References: <20180619094342.81831-6-tony@atomide.com>
        <20180627154152.BCECB60714@smtp.codeaurora.org>
        <20180628090739.GM112168@atomide.com>
Date: Thu, 28 Jun 2018 12:19:21 +0300
In-Reply-To: <20180628090739.GM112168@atomide.com> (Tony Lindgren's message of
        "Thu, 28 Jun 2018 02:07:39 -0700")
Message-ID: <8736x79skm.fsf@purkki.adurom.net> (sfid-20180628_111929_818730_E9BE99CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> * Kalle Valo <kvalo@codeaurora.org> [180627 15:44]:
>> 
>> I'll do s/wclore/wlcore/ to the title.
>
> OK thanks and sorry about that one.

No problem. I would not have even noticed the typo but I did 'list -s
new wlcore' (which prints all patches in new state with wlcore on the
subject) on my patchwork script and started to wonder where did the
patch 5 go :)

-- 
Kalle Valo
