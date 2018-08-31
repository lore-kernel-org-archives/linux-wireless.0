Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr40073.outbound.protection.outlook.com ([40.107.4.73]:2734
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727181AbeHaWaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 18:30:11 -0400
Subject: Re: [PATCH 28/28] mac80211: Don't wake up from PS for offchannel TX
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180831083130.15525-29-luca@coelho.fi>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <54391176-d540-9665-a51f-06eb75a7376f@bowerswilkins.com> (sfid-20180831_202134_291928_90BED723)
Date: Fri, 31 Aug 2018 11:21:13 -0700
MIME-Version: 1.0
In-Reply-To: <20180831083130.15525-29-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/31/2018 01:31 AM, Luca Coelho wrote:
> )
>
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
>
> Otherwise the offchannel frame might be queued due to
> IEEE80211_QUEUE_STOP_REASON_PS and later dropped (in
> ieee80211_tx_frags()).  Anyway, it doesn't make much sense to wake up
> the device during ROC.
>
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>
Please write a cover letter that explains what this patch series is 
trying to do.
28 patches are too many to catch the purpose at once.

Thanks,
Peter
