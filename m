Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44010 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeEVNuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:50:44 -0400
Date: Tue, 22 May 2018 06:50:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: Re: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180522135039.GH98604@atomide.com> (sfid-20180522_155048_034126_6D5BFBC0)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com>
 <20180521224339.GD98604@atomide.com>
 <3793c7c0d2b140389c7b92a407125650@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3793c7c0d2b140389c7b92a407125650@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [180522 06:42]:
> It still crash.
> The crash is different now.
> It also complains about:
> [   60.544224] Unbalanced enable for IRQ 65
> Need down/up of the interface to recover after it.

Oh OK so no need for this patch and interrupts are already
enabled at that point. Sounds like you found the real reason
with the patch you posted.

Regards,

Tony
