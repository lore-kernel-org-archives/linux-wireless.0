Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753673AbeBVLpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 06:45:03 -0500
Received: from mail-qt0-f181.google.com (mail-qt0-f181.google.com [209.85.216.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EECB217A5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2018 11:45:03 +0000 (UTC)
Received: by mail-qt0-f181.google.com with SMTP id d26so5877760qtk.10
        for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2018 03:45:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com>
References: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Thu, 22 Feb 2018 06:45:01 -0500
Message-ID: <CA+5PVA7uMEHHuDWxM+HWAnOOt=nHU-meLKJ-Zv+N6ywVnLmDpQ@mail.gmail.com> (sfid-20180222_124507_580657_6E98B108)
Subject: Re: [PULL] ath10k firmware 20180219
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 22, 2018 at 5:44 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Hi linux-firmware maintainers,
>
> here's a pull request for updating ath10k firmwares. Earlier I have been
> submitting these as patches but as the patches got pretty big I decided
> to try using pull requests instead.

Pull requests are easier to work with as well, so thanks.  Merged and
pushed out.

josh

> Please let me know if there are any problems.
>
> Kalle
>
> The following changes since commit 6d5131107f2ba67a13f469ac770a55f101ba654d:
>
>   rtl_bt: Add firmware and configuration files for the Bluetooth parts of RTL8821C and RTL8723D (2018-02-13 13:09:19 -0500)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git ath10k-20180219
>
> for you to fetch changes up to 9b3d016886a8e365f9493a724bf2945b97bcfe43:
>
>   ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053 (2018-02-19 12:03:36 +0200)
>
> ----------------------------------------------------------------
> Kalle Valo (9):
>       ath10k: QCA4019 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053
>       ath10k: QCA4019 hw1.0: update board-2.bin
>       ath10k: QCA6174 hw3.0: update firmware-6.bin to WLAN.RM.4.4.1-00079-QCARMSWPZ-1
>       ath10k: QCA6174 hw3.0: update board-2.bin
>       ath10k: QCA9377 hw1.0: update firmware-5.bin to WLAN.TF.1.0-00002-QCATFSWPZ-5
>       ath10k: QCA9887 hw1.0: update firmware-5.bin to 10.2.4-1.0-00037
>       ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.5.3-00053
>       ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00037
>       ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053
>
>  WHENCE                                            |  14 ++++++------
>  ath10k/QCA4019/hw1.0/board-2.bin                  | Bin 109172 -> 133452 bytes
>  ath10k/QCA4019/hw1.0/firmware-5.bin               | Bin 535412 -> 568636 bytes
>  ath10k/QCA6174/hw3.0/board-2.bin                  | Bin 501748 -> 551128 bytes
>  ath10k/QCA6174/hw3.0/firmware-6.bin               | Bin 727776 -> 730788 bytes
>  ath10k/QCA9377/hw1.0/firmware-5.bin               | Bin 605908 -> 783336 bytes
>  ath10k/QCA9377/hw1.0/notice_ath10k_firmware-5.txt |   4 ++--
>  ath10k/QCA9887/hw1.0/firmware-5.bin               | Bin 235880 -> 237584 bytes
>  ath10k/QCA9888/hw2.0/firmware-5.bin               | Bin 647460 -> 659708 bytes
>  ath10k/QCA988X/hw2.0/firmware-5.bin               | Bin 248188 -> 248108 bytes
>  ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt |  25 ++++++++++------------
>  ath10k/QCA9984/hw1.0/firmware-5.bin               | Bin 622060 -> 647380 bytes
>  12 files changed, 20 insertions(+), 23 deletions(-)
