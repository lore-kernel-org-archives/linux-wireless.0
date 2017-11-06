Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:56405 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdKFK7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 05:59:40 -0500
Received: by mail-wm0-f47.google.com with SMTP id z3so13255000wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 02:59:39 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
To: Simon Shields <simon@lineageos.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20171104132421.GA1541@archbox.home>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A004099.90200@broadcom.com> (sfid-20171106_115944_115977_79EAEB36)
Date: Mon, 6 Nov 2017 11:59:37 +0100
MIME-Version: 1.0
In-Reply-To: <20171104132421.GA1541@archbox.home>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/4/2017 2:24 PM, Simon Shields wrote:
> Some boards use an external 32khz clock for low-power
> mode timing. Make sure the clock is powered on while the chipset
> is active.

Do you have such a board? With the little documentation I can get my 
hands on here I wonder whether the clock needs to be enabled before the 
device is powered. If you have the hardware I would like to check some 
registers in the device.

Regards,
Arend
