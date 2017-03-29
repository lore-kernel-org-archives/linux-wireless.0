Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:36834 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755983AbdC2LPZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:15:25 -0400
Received: by mail-lf0-f47.google.com with SMTP id x137so5933187lff.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Mar 2017 04:15:24 -0700 (PDT)
Subject: Re: [PATCH 0/5] brcmfmac: network namespace support
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <fbababa2-225d-7f4d-ef3c-0787b39da638@gmail.com> (sfid-20170329_131813_585657_8BBA0312)
Date: Wed, 29 Mar 2017 13:15:19 +0200
MIME-Version: 1.0
In-Reply-To: <1490697808-5538-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2017 12:43 PM, Arend van Spriel wrote:
> This series intended for 4.12 includes:
> - support for network namespace
> - rework fwsignal module
> - small fix for suspend error code path
>
> Arend van Spriel (3):
>   brcmfmac: add support to move wiphy instance into network namespace
>   brcmfmac: restore bus state when enter_D3 fails
>   brcmfmac: no need for d11inf instance in brcmf_pno_start_sched_scan()
>
> Franky Lin (2):
>   brcmfmac: wrap brcmf_fws_init into bcdc layer
>   brcmfmac: move brcmf_fws_deinit to bcdc layer

It seems only 1 patch matches your patchset title. Maybe try picking them more
carefully ;)
