Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52524 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbEINrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:47:01 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/11] ath9k: Add a new debug flag for FFT spectral scan
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1430351482-59418-2-git-send-email-mickflemm@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, adrian.chadd@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Message-Id: <20150509134700.D5049140112@smtp.codeaurora.org> (sfid-20150509_154706_561223_DD003934)
Date: Sat,  9 May 2015 13:47:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> FFT spectral scan is a functionality that makes sense to have its own
> debug flag.
> 
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Thanks, 11 patches applied to wireless-drivers-next.git:

04a81e183d50 ath9k: Add a new debug flag for FFT spectral scan
e33f855d4368 ath9k: Fix hanlding of maximum magnitude index
58b5e4c731b5 ath9k: Move processing of FFT frames to different functions
7fa580c19349 ath9k: Perform integrity checks when processing FFT frames
72dd2cdaade6 ath9k: Support processing of multiple FFT frames per report.
0f2c75de6422 ath9k: Skip malformed frames on normal FFT report
9acc98b9ecf9 ath9k: No need for that extra memcpy
6b8f85a91883 ath9k: Skip FFT reports if we are out of output buffers
3ea2ce3f7e63 ath9k: No need for that extra memset
2aa56cca3571 ath9k: Mix the received FFT bins to the random pool
a534f3b60cac ath9k: Enable short repeat by default on ath9k_htc

Kalle Valo
