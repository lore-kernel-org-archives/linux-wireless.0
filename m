Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:15896
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751048AbdJRXiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 19:38:04 -0400
Subject: Re: [PATCH V6 0/5] Add TDLS feature for ath10k
To: yintang@qti.qualcomm.com, ath10k@lists.infradead.org
References: <TDLS for ath10k patches V6>
 <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <f634666f-cd35-279f-b161-4fa604b2dd69@bowerswilkins.com> (sfid-20171019_013809_898224_D52709A5)
Date: Wed, 18 Oct 2017 16:37:50 -0700
MIME-Version: 1.0
In-Reply-To: <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/15/2017 11:00 PM, yintang@qti.qualcomm.com wrote:
> From: Yingying Tang <yintang@qti.qualcomm.com>
>
> This patchset is for Rome PCIE chip, it will not affect other hardware
Please add your patchset history here until V6.
That's what cover letter is supposed to have.
> Yingying Tang (5):
>    mac80211: Enable TDLS peer buffer STA feature
>    ath10k: Enable TDLS peer buffer STA feature
>    ath10k: Enable TDLS peer inactivity detection
>    ath10k: Avoid to set WEP key for TDLS peer
>    ath10k: Fix TDLS peer TX data failure issue on encryped AP
>
>   drivers/net/wireless/ath/ath10k/mac.c     |    9 ++++-
>   drivers/net/wireless/ath/ath10k/wmi-tlv.c |   55 +++++++++++++++++++++++++++++
>   drivers/net/wireless/ath/ath10k/wmi-tlv.h |    9 +++++
>   drivers/net/wireless/ath/ath10k/wmi.h     |    1 +
>   include/net/mac80211.h                    |    4 +++
>   net/mac80211/tdls.c                       |    5 ++-
>   6 files changed, 81 insertions(+), 2 deletions(-)
>
