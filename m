Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41660 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbeDTTuM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 15:50:12 -0400
Received: by mail-wr0-f194.google.com with SMTP id v24-v6so25743234wra.8
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2018 12:50:11 -0700 (PDT)
From: Christian Lamparter <chunkeey@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ext.waldemar.rymarkiewicz@tieto.com,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 2/2] ath10k: search DT for qcom, ath10k-calibration-variant
Date: Fri, 20 Apr 2018 21:50:09 +0200
Message-ID: <2491530.mcAxvBYO6X@debian64> (sfid-20180420_215016_146458_5939F9C9)
In-Reply-To: <878t9jkzx7.fsf@kamboji.qca.qualcomm.com>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com> <3853747.Q0JJmSnsYM@debian64> <878t9jkzx7.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Donnerstag, 19. April 2018 16:56:36 CEST Kalle Valo wrote:
> [...]
> I have added them now, please check:
> 
> https://github.com/kvalo/ath10k-firmware/commit/a47bcf1e58c4d8914af0951a80fd8861368b700d
Yes, The RT-AC58U is now working much better. 

The updated RT-AC58U board-data is here:
<http://lists.infradead.org/pipermail/ath10k/2018-January/010770.html>

Regards
Christian
