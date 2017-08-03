Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60534 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbdHCKEg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 06:04:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v2 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security mode
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
Date: Thu, 03 Aug 2017 13:04:23 +0300
In-Reply-To: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Thu, 3 Aug 2017 17:37:57 +0800")
Message-ID: <87o9rxnf14.fsf@kamboji.qca.qualcomm.com> (sfid-20170803_120444_714902_B0CCD625)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security mode
>
> When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP security,
> firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
> probe response. The security type in softAP beacons confuse the
> supplicant in client side, and the user client will see [WPA-?] in
> supplicant scan result. So we set WPA_AUTH_DISABLED in softAP mode with 
> OPEN security.

The title is now duplicated, it's now in Subject and in the body, but I
can fix that.

-- 
Kalle Valo
