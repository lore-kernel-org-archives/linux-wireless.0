Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38796 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbdFHIYB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 04:24:01 -0400
Received: by mail-wm0-f51.google.com with SMTP id n195so25830427wmg.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jun 2017 01:24:00 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: Fix grammar issue in error message
To: Martin Michlmayr <tbm@cyrius.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170608080141.rswb2czupjeblqzq@jirafa.cyrius.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3bf898aa-c890-32ec-aa83-c7a1e7f56729@broadcom.com> (sfid-20170608_102404_916426_985FEB9E)
Date: Thu, 8 Jun 2017 10:23:58 +0200
MIME-Version: 1.0
In-Reply-To: <20170608080141.rswb2czupjeblqzq@jirafa.cyrius.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please use the driver name as prefix, ie. brcmfmac: iso cfg80211:

On 08-06-17 10:01, Martin Michlmayr wrote:
> Fix grammar issue in error message about ISO3166.

Other than that....

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
