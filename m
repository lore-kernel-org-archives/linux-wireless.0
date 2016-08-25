Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39498 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbcHYEtT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 00:49:19 -0400
Date: Wed, 24 Aug 2016 20:38:01 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-firmware@kernel.org
Subject: Re: [PATCH v2 0/6] linux-firmware: ath10k: update and add various
 firmware files
Message-ID: <20160825003801.GD20731@merlin.infradead.org> (sfid-20160825_064931_360746_4E5C63F7)
References: <20160824113134.5625.35574.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160824113134.5625.35574.stgit@potku.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2016 at 02:32:10PM +0300, Kalle Valo wrote:
> Hi,
> 
> here's a bigger ath10k firmware update. Support for four new hardware
> and smaller updates for existing hardware.
> 
> Kalle
> 
> v2:
> 
> * patch 4: Fix a typo in the commit log.

Applied series, thanks Kalle.

regards, --Kyle

> 
> ---
> 
> Kalle Valo (6):
>       ath10k: QCA4019 hw1.0: add firmware and board files
>       ath10k: QCA9887 hw1.0: add firmware and board files
>       ath10k: QCA9888 hw2.0: add firmware and board files
>       ath10k: QCA9984 hw1.0: add firmware and board files
>       ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.54
>       ath10k: QCA6174: update board files
> 
> 
>  WHENCE                                            |   18 +
>  ath10k/QCA4019/hw1.0/board-2.bin                  |  Bin
>  ath10k/QCA4019/hw1.0/firmware-5.bin               |  Bin
>  ath10k/QCA4019/hw1.0/notice_ath10k_firmware-5.txt |  589 +++++++++++++++++++++
>  ath10k/QCA6174/hw2.1/board-2.bin                  |  Bin
>  ath10k/QCA6174/hw3.0/board-2.bin                  |  Bin
>  ath10k/QCA9887/hw1.0/board.bin                    |  Bin
>  ath10k/QCA9887/hw1.0/firmware-5.bin               |  Bin
>  ath10k/QCA9887/hw1.0/notice_ath10k_firmware-5.txt |  328 ++++++++++++
>  ath10k/QCA9888/hw2.0/board-2.bin                  |  Bin
>  ath10k/QCA9888/hw2.0/firmware-5.bin               |  Bin
>  ath10k/QCA9888/hw2.0/notice_ath10k_firmware-5.txt |  589 +++++++++++++++++++++
>  ath10k/QCA988X/hw2.0/firmware-5.bin               |  Bin
>  ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt |   44 +-
>  ath10k/QCA9984/hw1.0/board-2.bin                  |  Bin
>  ath10k/QCA9984/hw1.0/firmware-5.bin               |  Bin
>  ath10k/QCA9984/hw1.0/notice_ath10k_firmware-5.txt |  589 +++++++++++++++++++++
>  17 files changed, 2134 insertions(+), 23 deletions(-)
>  create mode 100644 ath10k/QCA4019/hw1.0/board-2.bin
>  create mode 100644 ath10k/QCA4019/hw1.0/firmware-5.bin
>  create mode 100644 ath10k/QCA4019/hw1.0/notice_ath10k_firmware-5.txt
>  create mode 100644 ath10k/QCA9887/hw1.0/board.bin
>  create mode 100644 ath10k/QCA9887/hw1.0/firmware-5.bin
>  create mode 100644 ath10k/QCA9887/hw1.0/notice_ath10k_firmware-5.txt
>  create mode 100644 ath10k/QCA9888/hw2.0/board-2.bin
>  create mode 100644 ath10k/QCA9888/hw2.0/firmware-5.bin
>  create mode 100644 ath10k/QCA9888/hw2.0/notice_ath10k_firmware-5.txt
>  create mode 100644 ath10k/QCA9984/hw1.0/board-2.bin
>  create mode 100644 ath10k/QCA9984/hw1.0/firmware-5.bin
>  create mode 100644 ath10k/QCA9984/hw1.0/notice_ath10k_firmware-5.txt
> 
> 
