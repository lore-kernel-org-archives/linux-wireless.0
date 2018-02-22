Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36254 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753288AbeBVKod (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 05:44:33 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PULL] ath10k firmware 20180219
Date: Thu, 22 Feb 2018 10:44:28 +0000
Message-ID: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com> (sfid-20180222_114437_476646_FD925699)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-firmware maintainers,

here's a pull request for updating ath10k firmwares. Earlier I have been
submitting these as patches but as the patches got pretty big I decided
to try using pull requests instead.

Please let me know if there are any problems.

Kalle

The following changes since commit 6d5131107f2ba67a13f469ac770a55f101ba654d=
:

  rtl_bt: Add firmware and configuration files for the Bluetooth parts of R=
TL8821C and RTL8723D (2018-02-13 13:09:19 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git at=
h10k-20180219

for you to fetch changes up to 9b3d016886a8e365f9493a724bf2945b97bcfe43:

  ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053 (2018-02=
-19 12:03:36 +0200)

----------------------------------------------------------------
Kalle Valo (9):
      ath10k: QCA4019 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053
      ath10k: QCA4019 hw1.0: update board-2.bin
      ath10k: QCA6174 hw3.0: update firmware-6.bin to WLAN.RM.4.4.1-00079-Q=
CARMSWPZ-1
      ath10k: QCA6174 hw3.0: update board-2.bin
      ath10k: QCA9377 hw1.0: update firmware-5.bin to WLAN.TF.1.0-00002-QCA=
TFSWPZ-5
      ath10k: QCA9887 hw1.0: update firmware-5.bin to 10.2.4-1.0-00037
      ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.5.3-00053
      ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00037
      ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.5.3-00053

 WHENCE                                            |  14 ++++++------
 ath10k/QCA4019/hw1.0/board-2.bin                  | Bin 109172 -> 133452 b=
ytes
 ath10k/QCA4019/hw1.0/firmware-5.bin               | Bin 535412 -> 568636 b=
ytes
 ath10k/QCA6174/hw3.0/board-2.bin                  | Bin 501748 -> 551128 b=
ytes
 ath10k/QCA6174/hw3.0/firmware-6.bin               | Bin 727776 -> 730788 b=
ytes
 ath10k/QCA9377/hw1.0/firmware-5.bin               | Bin 605908 -> 783336 b=
ytes
 ath10k/QCA9377/hw1.0/notice_ath10k_firmware-5.txt |   4 ++--
 ath10k/QCA9887/hw1.0/firmware-5.bin               | Bin 235880 -> 237584 b=
ytes
 ath10k/QCA9888/hw2.0/firmware-5.bin               | Bin 647460 -> 659708 b=
ytes
 ath10k/QCA988X/hw2.0/firmware-5.bin               | Bin 248188 -> 248108 b=
ytes
 ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt |  25 ++++++++++--------=
----
 ath10k/QCA9984/hw1.0/firmware-5.bin               | Bin 622060 -> 647380 b=
ytes
 12 files changed, 20 insertions(+), 23 deletions(-)=
