Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42796 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbeEQS73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 14:59:29 -0400
Date: Thu, 17 May 2018 11:59:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180517185925.GN98604@atomide.com> (sfid-20180517_205933_067869_69A83D09)
References: <20180517185029.71716-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180517185029.71716-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180517 18:52]:
> Hi all,
> 
> Here's a series of patches to add runtime PM support for wlcore. It does not
> yet implement autosuspend support, but let's get this tested first as the
> autosuspend can mask enable/disable issues easily.

Sorry forgot to mention that you will want to have patch
"[PATCHv2] wlcore: sdio: Fix flakey SDIO runtime PM handling"
applied when testing to avoid bogus errors.

Regards,

Tony
