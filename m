Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38113 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdH3TNu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:13:50 -0400
Received: by mail-wm0-f51.google.com with SMTP id 187so7241811wmn.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:13:49 -0700 (PDT)
Subject: Re: [PATCH 15/30] brcmfmac: Tidy register definitions a little
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-16-ian@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <70e8dde4-083e-92c2-d4fb-60022520504b@broadcom.com> (sfid-20170830_211353_177746_248AA82E)
Date: Wed, 30 Aug 2017 21:13:46 +0200
MIME-Version: 1.0
In-Reply-To: <20170822112550.60311-16-ian@mnementh.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-08-17 13:25, Ian Molton wrote:
> Trivial tidy of register definitions.

Thought I already did, but....

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> ---
>   .../net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |  4 ++--
>   .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 19 ++++++++++---------
>   2 files changed, 12 insertions(+), 11 deletions(-)
