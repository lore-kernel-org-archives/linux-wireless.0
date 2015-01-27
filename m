Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22451 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbA0O1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 09:27:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: remove sw encryption for pmf
References: <1421750563-15945-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 16:26:59 +0200
In-Reply-To: <1421750563-15945-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 20 Jan 2015 11:42:42 +0100")
Message-ID: <8761bsb8p8.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_152715_512186_F12F90D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> From: Marek Kwaczynski <marek.kwaczynski@tieto.com>
>
> Software encryption was never necessary.
> Tested with fw 636 and fw 10.x.
>
> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied to ath.git.

-- 
Kalle Valo
