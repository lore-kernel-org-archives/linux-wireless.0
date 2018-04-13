Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0081.outbound.protection.outlook.com ([104.47.1.81]:63856
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752077AbeDMCWX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 22:22:23 -0400
Subject: Re: [PATCH v2] ath10k: Implement get_expected_throughput callback
To: Sven Eckelmann <sven.eckelmann@openmesh.com>, akolli@codeaurora.org
References: <1521814034-17880-1-git-send-email-akolli@codeaurora.org>
 <2322769.sx4MhzsvNg@bentobox>
 <7428dc3685e146dca147805b6a1bc5d2@codeaurora.org>
 <1580002.5HauTVtcdp@bentobox>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Antonio Quartulli <a@unstable.cc>,
        Felix Fietkau <nbd@nbd.name>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless-owner@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <75b3a88c-518f-f464-df1d-7c1cd8e54b89@bowerswilkins.com> (sfid-20180413_042227_617227_805E8551)
Date: Thu, 12 Apr 2018 19:22:05 -0700
MIME-Version: 1.0
In-Reply-To: <1580002.5HauTVtcdp@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anilkumar,


On 03/27/2018 11:37 PM, Sven Eckelmann wrote:
> On Mittwoch, 28. März 2018 11:41:51 CEST akolli@codeaurora.org wrote:
> [...]
>> The rate average and throughput are relative. no?
Can you share the output number from your new function?
It may help us to understand a little bit more how well the new function 
works.

Thanks,
Peter
