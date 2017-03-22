Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:35618 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759433AbdCVTn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:43:57 -0400
Received: by mail-qt0-f181.google.com with SMTP id x35so159881418qtc.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 12:43:15 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: wrap brcmf_fws_(de)init into bcdc layer
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170321134422.888-1-zajec5@gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c5a57e90-8884-8976-fd3f-5b157abb4189@broadcom.com> (sfid-20170322_204537_406112_FE7E31A0)
Date: Wed, 22 Mar 2017 20:43:11 +0100
MIME-Version: 1.0
In-Reply-To: <20170321134422.888-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-3-2017 14:44, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> fwsignal is only used by bcdc. Create new protocol interface functions
> for core code to perform proto specific (de)initialization. This makes
> core agnostic to the protocol which will allow further optimizations.
> We will be able to avoid compiling unused protocols or modularize them.

Thanks, Rafał

Franky had tackled this with two patches, which are queued to be submitted.

Regards,
Arend
