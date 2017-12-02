Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58172 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdLBOpT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:45:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, Wright Feng <Wright.Feng@cypress.com>,
        Stanley Hsu <Stanley.Hsu@cypress.com>
Subject: Re: [PATCH] brcmfmac: Add sg parameters dts parsing
References: <20171201075542.GA31376@aremote07.aus.cypress.com>
        <5A211508.6030603@broadcom.com>
Date: Sat, 02 Dec 2017 16:45:12 +0200
In-Reply-To: <5A211508.6030603@broadcom.com> (Arend van Spriel's message of
        "Fri, 1 Dec 2017 09:38:32 +0100")
Message-ID: <874lp9w5mv.fsf@kamboji.qca.qualcomm.com> (sfid-20171202_154523_081844_410819A4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 12/1/2017 8:55 AM, Chi-Hsien Lin wrote:
>> broken_sg_support, sd_head_align, and sd_sgentry_align are used in
>> brcmfmac code but not configurable in dts file. Add the parsing logic.
>> Now they can be configured like below in dts:
>> 	brcm,broken_sg_support;
>> 	brcm,sd_head_align =/bits/  16 <4>;
>> 	brcm,sd_sgentry_align =/bits/  16 <4>;
>
> Hi Chi-Hsien,
>
> For device tree support you should submit a separate commit on the dt
> binding specification. For broadcom fullmac chipsets binding spec can
> be found in
> Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt.

And remember to CC the device tree mailing list. I need an ack from the
DT maintainers before I can apply the patch.

-- 
Kalle Valo
