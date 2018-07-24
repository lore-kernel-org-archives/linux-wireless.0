Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60428 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388361AbeGXRP6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 13:15:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, twooden@rivetnetworks.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: add more card IDs for 9000 series
References: <1531824236-25442-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Tue, 24 Jul 2018 19:08:43 +0300
In-Reply-To: <1531824236-25442-1-git-send-email-emmanuel.grumbach@intel.com>
        (Emmanuel Grumbach's message of "Tue, 17 Jul 2018 13:43:56 +0300")
Message-ID: <87a7qg8vlg.fsf@purkki.adurom.net> (sfid-20180724_180850_262011_A70B8178)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> Add new device IDs for the 9000 series.
>
> Cc: stable@vger.kernel.org [4.14+]

This is wrong, it should be:

Cc: stable@vger.kernel.org # 4.14

I guess because of this you had in Cc field:

[4.14+]@vger.kernel.org

I'll fix this.

https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3

-- 
Kalle Valo
