Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35613 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756656AbdELOnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 10:43:40 -0400
Received: by mail-io0-f169.google.com with SMTP id f102so41255756ioi.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 07:43:39 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 12 May 2017 20:13:18 +0530
Message-ID: <CABPxzY+mQ-G6PTsQV9_WVgju4bmQHwxKKW070j7v6=DDgZop4Q@mail.gmail.com> (sfid-20170512_164343_983162_D45049DE)
Subject: ath10k: controlling TX aggregation
To: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am doing some comparative tests, wanted to configure common
settings btw all STA's. wanted to limit agg_size to 24 in ath10k with
the below command.

echo "3 24" > /sys/kernel/debug/ieee80211/phy0/ath10k/htt_max_amsdu_ampdu

The ADDBA request still has 64 and when i run iperf it is aggregating 64 frames.

Except for 1 no number takes effect. If i configure 1 there is no ADDBA exchange
initiated by ath10k.

Is this expected? Can we control the aggregation size through driver?

latest wireless-drivers-next and linux-firmware git is used.

-- 
Thanks,
Regards,
Chaitanya T K.
