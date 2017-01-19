Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56202 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdASJAe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 04:00:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Gavin Li <gavinli@thegavinli.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        Stable <stable@vger.kernel.org>, Gavin Li <git@thegavinli.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH v3] brcmfmac: fix incorrect event channel deduction
References: <20170117232405.7672-1-gavinli@thegavinli.com>
        <bab86bb5-7815-e5ea-053d-ed6b18af6677@broadcom.com>
        <CA+GxvY43AbKOVJFWAxHg1Gku=LD-dveHY8m6=zPPu9qR4+r=Fg@mail.gmail.com>
Date: Thu, 19 Jan 2017 10:48:36 +0200
In-Reply-To: <CA+GxvY43AbKOVJFWAxHg1Gku=LD-dveHY8m6=zPPu9qR4+r=Fg@mail.gmail.com>
        (Gavin Li's message of "Wed, 18 Jan 2017 10:39:07 -0800")
Message-ID: <87inpbh1uj.fsf@purkki.adurom.net> (sfid-20170119_100036_792396_0EC3C2E3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gavin Li <gavinli@thegavinli.com> writes:

> I think calling this a performance regression is a bit understated; my
> download speed jumped from 1Mbit/s back up to 40MBit/s after applying
> the patch due to the sheer amount of packets being incorrectly
> processed.
>
> In addition, processing arbitrary data frames as firmware events might
> be a security vulnerability.

You should always mention valuable information like this in the commit
log, don't make us maintainers (and others) guessing the symptoms and
impact.

-- 
Kalle Valo
