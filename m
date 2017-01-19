Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbdASI4F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 03:56:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Gavin Li <gavinli@thegavinli.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Gavin Li <git@thegavinli.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Stable <stable@vger.kernel.org>, linux-wireless@vger.kernel.org,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: [PATCH v3] brcmfmac: fix incorrect event channel deduction
References: <20170117232405.7672-1-gavinli@thegavinli.com>
        <bab86bb5-7815-e5ea-053d-ed6b18af6677@broadcom.com>
        <CA+GxvY43AbKOVJFWAxHg1Gku=LD-dveHY8m6=zPPu9qR4+r=Fg@mail.gmail.com>
        <87inpbh1uj.fsf@purkki.adurom.net>
        <CA+GxvY6ho89L-Ye7MrbtVM=i+Ck8YSH7JaSG1p=WzH5u_Be0_A@mail.gmail.com>
Date: Thu, 19 Jan 2017 10:55:57 +0200
In-Reply-To: <CA+GxvY6ho89L-Ye7MrbtVM=i+Ck8YSH7JaSG1p=WzH5u_Be0_A@mail.gmail.com>
        (Gavin Li's message of "Thu, 19 Jan 2017 08:51:11 +0000")
Message-ID: <87lgu7pgwy.fsf@kamboji.qca.qualcomm.com> (sfid-20170119_095609_332684_E221D9CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gavin Li <gavinli@thegavinli.com> writes:

> Should I make a v4 patch with an updated log?

No need, I'll just copy your description of the bug to the commit log
before I commit it.

-- 
Kalle Valo
