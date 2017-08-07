Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36308 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752986AbdHGL03 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 07:26:29 -0400
Received: by mail-wr0-f171.google.com with SMTP id y43so600870wrd.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 04:26:29 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 10/34] brcmfmac: Rename bcmerror to err
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-11-ian@mnementh.co.uk>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
Message-ID: <59884E63.7070100@broadcom.com> (sfid-20170807_132632_183641_D369D52A)
Date: Mon, 7 Aug 2017 13:26:27 +0200
MIME-Version: 1.0
In-Reply-To: <20170726202557.15632-11-ian@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/26/2017 10:25 PM, Ian Molton wrote:
> Trivial cleanup of nasty variable name

Did not look, but here is...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
