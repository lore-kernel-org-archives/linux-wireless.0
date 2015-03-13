Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [205.233.59.134] ([205.233.59.134]:44647 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbCMUsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 16:48:37 -0400
Date: Fri, 13 Mar 2015 16:47:30 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: add firmware 10.2.4.45 as firmware-4.bin
Message-ID: <20150313204730.GA30928@merlin.infradead.org> (sfid-20150313_214840_680924_15863284)
References: <1426160112-4261-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426160112-4261-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2015 at 01:35:12PM +0200, Kalle Valo wrote:
> This is the latest firmware from 10.2.4 firmware branch.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Pardon my ignorance... It looks like your driver needs more than just
firmware-4.bin... How are distros supposed to use this? Symlink it into
firmware.bin which it seems the driver looks for?

--Kyle

> ---
>  LICENSE.QualcommAtheros_ath10k                    |   47 ++++
>  WHENCE                                            |    9 +
>  ath10k/QCA988X/hw2.0/firmware-4.bin               |  Bin 0 -> 241892 bytes
>  ath10k/QCA988X/hw2.0/notice_ath10k_firmware-4.txt |  301 +++++++++++++++++++++
>  4 files changed, 357 insertions(+)
>  create mode 100644 LICENSE.QualcommAtheros_ath10k
>  create mode 100644 ath10k/QCA988X/hw2.0/firmware-4.bin
>  create mode 100644 ath10k/QCA988X/hw2.0/notice_ath10k_firmware-4.txt
