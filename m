Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59974 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756392AbdELOpv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 10:45:51 -0400
Subject: Re: ath10k: controlling TX aggregation
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
References: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <b830b657-3f73-de7f-d61c-1565dc14c2ef@candelatech.com> (sfid-20170512_164554_157131_8C8D8481)
Date: Fri, 12 May 2017 07:45:49 -0700
MIME-Version: 1.0
In-Reply-To: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What chipset, and what firmware version?

Thanks,
Ben

On 05/12/2017 07:43 AM, Krishna Chaitanya wrote:
> Hi,
>
> I am doing some comparative tests, wanted to configure common
> settings btw all STA's. wanted to limit agg_size to 24 in ath10k with
> the below command.
>
> echo "3 24" > /sys/kernel/debug/ieee80211/phy0/ath10k/htt_max_amsdu_ampdu
>
> The ADDBA request still has 64 and when i run iperf it is aggregating 64 frames.
>
> Except for 1 no number takes effect. If i configure 1 there is no ADDBA exchange
> initiated by ath10k.
>
> Is this expected? Can we control the aggregation size through driver?
>
> latest wireless-drivers-next and linux-firmware git is used.
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
