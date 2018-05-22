Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeEVICo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 04:02:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: "Reizer\, Eyal" <eyalr@ti.com>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol\, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn\, Maital" <maitalm@ti.com>,
        "Altshul\, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy\, Chen" <c-loewy@ti.com>
Subject: Re: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
References: <20180517185029.71716-1-tony@atomide.com>
        <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
        <20180521163830.GZ98604@atomide.com>
Date: Tue, 22 May 2018 11:02:36 +0300
In-Reply-To: <20180521163830.GZ98604@atomide.com> (Tony Lindgren's message of
        "Mon, 21 May 2018 09:38:30 -0700")
Message-ID: <87efi4f78j.fsf@kamboji.qca.qualcomm.com> (sfid-20180522_100315_989155_A2105A39)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> * Reizer, Eyal <eyalr@ti.com> [180521 07:31]:
>> > Here's a series of patches to add runtime PM support for wlcore. It does not
>> > yet implement autosuspend support, but let's get this tested first as the
>> > autosuspend can mask enable/disable issues easily.
>> 
>> Testing on BBB+WL1837 cape, scan, recovery, down/up and basic traffic seems ok now.
>> Of course we need to test some more.
>
> Thanks for testing. Yes let's do more testing, no rush with these.
> Hopefully they'll be ready for v4.19 merge window though.

So I can drop the patchset now and you will resend once it's ready?

-- 
Kalle Valo
