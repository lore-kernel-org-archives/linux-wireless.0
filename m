Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:18587
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753397AbeD3TCA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 15:02:00 -0400
Subject: Re: [PATCH 1/2] ath: Add support to get the detected radar
 specifications
To: Sriram R <srirrama@codeaurora.org>, ath10k@lists.infradead.org
References: <1525110339-25326-1-git-send-email-srirrama@codeaurora.org>
 <1525110339-25326-2-git-send-email-srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <cf60f81c-9466-ac52-e902-413fe3163490@bowerswilkins.com> (sfid-20180430_210206_321583_9363396B)
Date: Mon, 30 Apr 2018 12:01:45 -0700
MIME-Version: 1.0
In-Reply-To: <1525110339-25326-2-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/30/2018 10:45 AM, Sriram R wrote:
> This enables ath10k/ath9k drivers to collect the specifications of the
> radar type once it is detected by the dfs pattern detector unit.
> Usage of the collected info is specific to driver implementation.
> For example, collected radar info could be used by the host driver
> to send to co-processors for additional processing/validation.
What kind of additional processing/validation does it do?
Please give us more details for that.

Thanks,
Peter
