Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f41.google.com ([209.85.208.41]:45772 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbeF3S4J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 14:56:09 -0400
Received: by mail-ed1-f41.google.com with SMTP id g15-v6so4709492edr.12
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jun 2018 11:56:09 -0700 (PDT)
Subject: Re: [PATCH] mac80211_hwsim: Add support for HE
To: kbuild test robot <lkp@intel.com>, Luca Coelho <luca@coelho.fi>
References: <20180630114930.25738-1-luca@coelho.fi>
 <201806302128.sZFW1pVY%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B37D248.6040008@broadcom.com> (sfid-20180630_205613_922683_F10CCC82)
Date: Sat, 30 Jun 2018 20:56:08 +0200
MIME-Version: 1.0
In-Reply-To: <201806302128.sZFW1pVY%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/30/2018 5:42 PM, kbuild test robot wrote:
>    2560			.he_mcs_nss_supp = {
>> >2561				.rx_msc_80 = cpu_to_le16(0xfffa),
>> >2562				.tx_msc_80 = cpu_to_le16(0xfffa),
>> >2563				.rx_msc_160 = cpu_to_le16(0xffff),
>> >2564				.tx_msc_160 = cpu_to_le16(0xffff),
>> >2565				.rx_msc_80p80 = cpu_to_le16(0xffff),
>> >2566				.tx_msc_80p80 = cpu_to_le16(0xffff),
>    2567			},

I believe I commented in earlier version that those fields in the type 
defintion should be mcs iso msc and this initializer did not get fixed?

Regards,
Arend
