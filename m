Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47526 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab3LWOEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 09:04:20 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add set_bitrate_mask callback
References: <1387653946-2988-1-git-send-email-janusz.dziedzic@tieto.com>
	<87d2koxd8m.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=q4qgexWTfmmizt5+kNjkM6MfscYp=0VvEnj4YMHrRc1A@mail.gmail.com>
Date: Mon, 23 Dec 2013 16:04:14 +0200
In-Reply-To: <CALhHN=q4qgexWTfmmizt5+kNjkM6MfscYp=0VvEnj4YMHrRc1A@mail.gmail.com>
	(Janusz Dziedzic's message of "Mon, 23 Dec 2013 14:55:12 +0100")
Message-ID: <87k3evvf35.fsf@kamboji.qca.qualcomm.com> (sfid-20131223_150423_708301_41EE1942)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

>> Bitfields are frowned upon in kernel, better to use SM() and MS().
>>
> I don't use them, just put as a documentation.

Ok, then you can just document that within comments.

-- 
Kalle Valo
