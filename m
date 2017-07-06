Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43091 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752518AbdGFMUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 08:20:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Increase buffer len to print all wmi services.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1499059956-30051-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1499059956-30051-1-git-send-email-c_traja@qti.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <58c15d01a59543be9123d77f3ac15417@eusanexr01a.eu.qualcomm.com> (sfid-20170706_142016_840132_7A72F65B)
Date: Thu, 6 Jul 2017 05:19:52 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_traja@qti.qualcomm.com wrote:

> All wmi_services are not printing when we give below command.
> 
> cat /sys/kernel/debug/ieee80211/phyX/ath10k/wmi_services
> 
> This patch increases the buffer_len to 8192 to print all the wmi_services.
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

75e0dde2abf6 ath10k: increase buffer len to print all wmi services

-- 
https://patchwork.kernel.org/patch/9821955/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
