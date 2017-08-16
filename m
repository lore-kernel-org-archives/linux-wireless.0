Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751781AbdHPOAJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 10:00:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>
Subject: Re: [PATCH] brcmfmac: add CLM download support
References: <1502783044-23715-1-git-send-email-wright.feng@cypress.com>
Date: Wed, 16 Aug 2017 17:00:02 +0300
In-Reply-To: <1502783044-23715-1-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Tue, 15 Aug 2017 15:44:04 +0800")
Message-ID: <87tw177gv1.fsf@kamboji.qca.qualcomm.com> (sfid-20170816_160015_240480_B3263AF9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>
> The firmware for brcmfmac devices includes information regarding
> regulatory constraints. For certain devices this information is kept
> separately in a binary form that needs to be downloaded to the device.
> This patch adds support to download this so-called CLM blob file. It
> uses the same naming scheme as the other firmware files with extension
> of .clm_blob.

What if the file does not exist, what happens then? I assume that the
file is optional but the commit log should document that.

-- 
Kalle Valo
