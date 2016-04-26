Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54235 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbcDZJbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 05:31:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] rt2800lib: enable MFP if hw crypt is disabled
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461170494-576-1-git-send-email-yeohchunyeow@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
	helmut.schaa@googlemail.com, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Message-Id: <20160426093125.0EC23601A1@smtp.codeaurora.org> (sfid-20160426_113138_798729_6092AB3C)
Date: Tue, 26 Apr 2016 09:31:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
> care of the crypto with software encryption/decryption
> and thus, MFP can be used.
> 
> Tested for secured mesh using ath9k_htc and ath9k.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> 
> v2: set MFP correctly (Stanislaw Gruszka)
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
