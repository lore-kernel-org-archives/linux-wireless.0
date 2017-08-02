Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbdHBJar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 05:30:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/opensecurity mode
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
Date: Wed, 02 Aug 2017 12:30:42 +0300
In-Reply-To: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Tue, 1 Aug 2017 16:48:05 +0800")
Message-ID: <87r2wu48ql.fsf@codeaurora.org> (sfid-20170802_113050_430042_82DA8EE0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP secuirty,
> firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
> probe response.

typo: "secuirty"

> It confuses the supplicant in sation client by the security type from
> softAP beacon and we will see [WPA-?] in scan result. 

"sation"? Also the sentence is a bit unclear.

> So we set WPA_AUTH_DISABLED in softAP mode with opensecurity.

Space missing between "open" and "security".

-- 
Kalle Valo
