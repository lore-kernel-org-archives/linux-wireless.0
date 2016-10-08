Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35739 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbcJHOWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Oct 2016 10:22:13 -0400
Received: by mail-qt0-f173.google.com with SMTP id f6so32447228qtd.2
        for <linux-wireless@vger.kernel.org>; Sat, 08 Oct 2016 07:22:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1475852332-18217-2-git-send-email-akolli@qti.qualcomm.com>
References: <1475852332-18217-1-git-send-email-akolli@qti.qualcomm.com> <1475852332-18217-2-git-send-email-akolli@qti.qualcomm.com>
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Sat, 8 Oct 2016 22:16:37 +0800
Message-ID: <CAEFj985tCc_4Q_zfwRtoT0fjfZv0u_c5E8SRSQVz=V4tiHh+GA@mail.gmail.com> (sfid-20161008_162217_731802_35E45E88)
Subject: Re: [PATCH 1/2] ath10k: add per peer htt tx stats support for 10.4
To: akolli@qti.qualcomm.com
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        akolli@codeaurora.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 7, 2016 at 10:58 PM,  <akolli@qti.qualcomm.com> wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
> event, Firmware sends one HTT event for every four PPDUs.
> HTT payload has success pkts/bytes, failed pkts/bytes, retry
> pkts/bytes and rate info per ppdu.
> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
> which are nowadays enabled by default.
>
> Parse peer stats and update the tx rate information per STA.
>
> tx rate, Peer stats are tested on QCA4019 with Firmware version
> 10.4-3.2.1-00028.
>

Is QCA988X supported? I have tried to test with
firmware-5.bin_10.2.4.70.56 but not working.

---
Chun-Yeow
