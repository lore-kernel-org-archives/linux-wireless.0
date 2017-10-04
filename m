Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63037 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdJDIoo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 04:44:44 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 0/3] linux-firmware: ath10k update 20170918
Date: Wed, 4 Oct 2017 08:44:39 +0000
Message-ID: <87lgkrxpxk.fsf@kamboji.qca.qualcomm.com> (sfid-20171004_104456_649576_DC2B9C08)
References: <1505746857-31938-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1505746857-31938-1-git-send-email-kvalo@qca.qualcomm.com> (Kalle
        Valo's message of "Mon, 18 Sep 2017 18:00:54 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Few firmware fixes to user reported issues for ath10k, but the other "fix=
"
> being a revert back to older firmware. Also a small board-2.bin update.
>
> Kalle Valo (3):
>   ath10k: QCA6174 hw3.0: update firmware-6.bin to
>     WLAN.RM.4.4.1-00051-QCARMSWP-1
>   ath10k: QCA6174 hw3.0: update board-2.bin
>   Revert "ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.63-2"
>
>  WHENCE                                            |   4 +-
>  ath10k/QCA6174/hw3.0/board-2.bin                  | Bin 477060 -> 501748=
 bytes
>  ath10k/QCA6174/hw3.0/firmware-6.bin               | Bin 711408 -> 727776=
 bytes
>  ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt |  97 +++++-----------=
------
>  ath10k/QCA988X/hw2.0/firmware-5.bin               | Bin 249384 -> 248188=
 bytes
>  5 files changed, 25 insertions(+), 76 deletions(-)

Ping? These fix serious regressions reported by many so it would be
really good to get these to linux-firmware soon.

--=20
Kalle Valo=
