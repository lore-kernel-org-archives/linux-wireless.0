Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:34872
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751311AbeCESsY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 13:48:24 -0500
Subject: Re: [PATCH 1/2] ath10k: Add WMI FWTEST command support
To: Anilkumar Kolli <akolli@codeaurora.org>, ath10k@lists.infradead.org
References: <1520233148-26050-1-git-send-email-akolli@codeaurora.org>
 <1520233148-26050-2-git-send-email-akolli@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <94f133b3-ee5d-6ed8-d7e8-20dff9aaede2@bowerswilkins.com> (sfid-20180305_194829_840905_F43B1758)
Date: Mon, 5 Mar 2018 10:48:07 -0800
MIME-Version: 1.0
In-Reply-To: <1520233148-26050-2-git-send-email-akolli@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sathishkumar Muruganandam <murugana@codeaurora.org>
> This patch adds support for WMI_FWTEST_CMD.
> This command is used for setting the wifi parameters.

It's too lack of information in commit message.
You should add such what values are acceptable for which purpose by each 
param_id and param_value to make this changes meaningful to community.

Thanks,
Peter
