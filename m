Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:34947 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030658AbbKEIyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 03:54:55 -0500
Received: by ykek133 with SMTP id k133so119761168yke.2
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2015 00:54:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87lhadbqhi.fsf@kamboji.qca.qualcomm.com>
References: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
	<1446638015-23310-5-git-send-email-bartosz.markowski@tieto.com>
	<87lhadbqhi.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 5 Nov 2015 09:54:54 +0100
Message-ID: <CACKGw+HSx6btFRtj9gMr=ORd9zEbo8=6dukUxMnJkEn-+-Ud5A@mail.gmail.com> (sfid-20151105_095458_942091_D4E80E74)
Subject: Re: [PATCH 4/4] ath10k: add QCA9377 hw1.0 support
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 November 2015 at 18:53, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> Add new BMI target version and chip id revision. Register it
>> on supported chips list.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> This one has whitespace issues:
>
> drivers/net/wireless/ath/ath10k/core.c:163: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:163: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:164: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:164: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:165: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:165: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:166: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:166: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:167: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:167: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:168: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:168: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:169: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:169: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:170: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:170: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:171: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:171: please, no spaces at the start of a line
> drivers/net/wireless/ath/ath10k/core.c:172: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/core.c:172: please, no spaces at the start of a line

Sorry about that. I've resend it now.



-- 
Bartosz
