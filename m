Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57745 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbbKDBsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 20:48:13 -0500
Date: Tue, 3 Nov 2015 20:48:10 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2] ath10k: add notice.txt references to WHENCE
Message-ID: <20151104014810.GD12383@merlin.infradead.org> (sfid-20151104_024818_321386_AB12570E)
References: <1445354009-20338-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445354009-20338-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2015 at 06:13:29PM +0300, Kalle Valo wrote:
> This is to make sure that the notice files get automatically included.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

applied.

> ---
>  WHENCE |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/WHENCE b/WHENCE
> index 9b7e8e8526aa..ded2e7ad161b 100755
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2393,17 +2393,22 @@ Driver: ath10k - Qualcomm Atheros support for QCA988x family of chips
>  File: ath10k/QCA988X/hw2.0/board.bin
>  File: ath10k/QCA988X/hw2.0/firmware-4.bin
>  Version: 10.2.4.45
> +Licence: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-4.txt
>  File: ath10k/QCA988X/hw2.0/firmware-5.bin
>  Version: 10.2.4.70.9-2
> +Licence: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt
>  File: ath10k/QCA6174/hw2.1/board.bin
>  File: ath10k/QCA6174/hw2.1/firmware-5.bin
>  Version: WLAN.RM.1.1-00141
> +Licence: ath10k/QCA6174/hw2.1/notice_ath10k_firmware-5.txt
>  File: ath10k/QCA6174/hw3.0/board.bin
>  File: ath10k/QCA6174/hw3.0/firmware-4.bin
>  Version: WLAN.RM.2.0-00180-QCARMSWPZ-1
> +Licence: ath10k/QCA6174/hw3.0/notice_ath10k_firmware-4.txt
>  File: ath10k/QCA99X0/hw2.0/board.bin
>  File: ath10k/QCA99X0/hw2.0/firmware-5.bin
>  Version: 10.4.1.00030-1
> +Licence: ath10k/QCA99X0/hw2.0/notice_ath10k_firmware-5.txt
>  
>  Licence: Redistributable. See LICENSE.QualcommAtheros_ath10k for details
>  
> -- 
> 1.7.9.5
> 
> 
