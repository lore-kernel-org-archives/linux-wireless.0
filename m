Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:32903 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755978AbdC2L1X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:27:23 -0400
Received: by mail-lf0-f53.google.com with SMTP id h125so6096068lfe.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 04:27:21 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: wrap brcmf_fws_(de)init into bcdc layer
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170321134422.888-1-zajec5@gmail.com>
 <c5a57e90-8884-8976-fd3f-5b157abb4189@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <fc201610-06ac-ec65-1ec4-7c593a91f935@gmail.com> (sfid-20170329_133000_881887_55639D7D)
Date: Wed, 29 Mar 2017 13:27:19 +0200
MIME-Version: 1.0
In-Reply-To: <c5a57e90-8884-8976-fd3f-5b157abb4189@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2017 08:43 PM, Arend Van Spriel wrote:
> On 21-3-2017 14:44, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> fwsignal is only used by bcdc. Create new protocol interface functions
>> for core code to perform proto specific (de)initialization. This makes
>> core agnostic to the protocol which will allow further optimizations.
>> We will be able to avoid compiling unused protocols or modularize them.
>
> Thanks, Rafał
>
> Franky had tackled this with two patches, which are queued to be submitted.

Given that your implementation (you now published) doesn't do any magic, is
there any real problem with my patch except of /not invented here/?

[0] https://en.wikipedia.org/wiki/Not_invented_here
