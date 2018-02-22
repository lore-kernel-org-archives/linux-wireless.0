Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:54883 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753411AbeBVK7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 05:59:06 -0500
Subject: Re: [PULL] ath10k firmware 20180219
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <0e9db63d-41e9-eeb3-00d1-73b20df4bb3f@dd-wrt.com> (sfid-20180222_115910_111796_5F228259)
Date: Thu, 22 Feb 2018 11:59:02 +0100
MIME-Version: 1.0
In-Reply-To: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

on 9984 i see these messages with this firmware from time to time

[272972.950788] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[272982.868922] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[335550.123780] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[335550.156332] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[335550.158813] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[335550.193144] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[365157.869540] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
[365157.902452] ath10k_pci 0000:01:00.0: Unknown eventid: 36925


according to the WMI header this maybe a critical internal error

Am 22.02.2018 um 11:44 schrieb Kalle Valo:
> Hi linux-firmware maintainers,
>
> here's a pull request for updating ath10k firmwares. Earlier I have been
> submitting these as patches but as the patches got pretty big I decided
> to try using pull requests instead.
>
> Please let me know if there are any problems.
>
> Kalle
>
> The following changes since commit 6d5131107f2ba67a13f469ac770a55f101ba654d:
>
>    rtl_bt: Add firmware and configuration files for the Bluetooth parts of RTL8821C and RTL8723D (2018-02-13 13:09:19 -0500)
>
> are available in the git repository at:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git ath10k-20180219
>
> for you to fetch changes up to 9b3d016886a8e365f9493a724bf2945b97bcfe43:
>
>    ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053 (2018-02-19 12:03:36 +0200)
>
> ----------------------------------------------------------------
> Kalle Valo (9):
>        ath10k: QCA4019 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053
>        ath10k: QCA4019 hw1.0: update board-2.bin
>        ath10k: QCA6174 hw3.0: update firmware-6.bin to WLAN.RM.4.4.1-00079-QCARMSWPZ-1
>        ath10k: QCA6174 hw3.0: update board-2.bin
>        ath10k: QCA9377 hw1.0: update firmware-5.bin to WLAN.TF.1.0-00002-QCATFSWPZ-5
>        ath10k: QCA9887 hw1.0: update firmware-5.bin to 10.2.4-1.0-00037
>        ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.5.3-00053
>        ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00037
>        ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053
>
>   WHENCE                                            |  14 ++++++------
>   ath10k/QCA4019/hw1.0/board-2.bin                  | Bin 109172 -> 133452 bytes
>   ath10k/QCA4019/hw1.0/firmware-5.bin               | Bin 535412 -> 568636 bytes
>   ath10k/QCA6174/hw3.0/board-2.bin                  | Bin 501748 -> 551128 bytes
>   ath10k/QCA6174/hw3.0/firmware-6.bin               | Bin 727776 -> 730788 bytes
>   ath10k/QCA9377/hw1.0/firmware-5.bin               | Bin 605908 -> 783336 bytes
>   ath10k/QCA9377/hw1.0/notice_ath10k_firmware-5.txt |   4 ++--
>   ath10k/QCA9887/hw1.0/firmware-5.bin               | Bin 235880 -> 237584 bytes
>   ath10k/QCA9888/hw2.0/firmware-5.bin               | Bin 647460 -> 659708 bytes
>   ath10k/QCA988X/hw2.0/firmware-5.bin               | Bin 248188 -> 248108 bytes
>   ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt |  25 ++++++++++------------
>   ath10k/QCA9984/hw1.0/firmware-5.bin               | Bin 622060 -> 647380 bytes
>   12 files changed, 20 insertions(+), 23 deletions(-)


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
