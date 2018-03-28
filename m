Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57434 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753164AbeC1PRA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 11:17:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/12] ath10k: Add qmi service for wlan qmi client
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522042736-25618-1-git-send-email-govinds@codeaurora.org>
References: <1522042736-25618-1-git-send-email-govinds@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Message-Id: <20180328151659.9DC3F60AFB@smtp.codeaurora.org> (sfid-20180328_171703_812365_EDA1D174)
Date: Wed, 28 Mar 2018 15:16:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> wrote:

> WLAN qmi server running in Q6 dsp exposes host
> to target cold boot qmi handshake.
> Add WLAN QMI service helpers for WLAN serivice.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

This introduced two new ath10k-check warnings:

drivers/net/wireless/ath/ath10k/qmi_svc_v01.h:304: line over 90 characters
drivers/net/wireless/ath/ath10k/qmi_svc_v01.h:464: line over 90 characters

-- 
https://patchwork.kernel.org/patch/10307161/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
