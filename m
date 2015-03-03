Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45575 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbbCCOna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 09:43:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: avoid memcpy when downloading firmware
References: <1425356643-2707-1-git-send-email-fred.chou.nd@gmail.com>
	<1425362407.5130.161.camel@edumazet-glaptop2.roam.corp.google.com>
	<54F5C813.4030505@gmail.com>
Date: Tue, 03 Mar 2015 16:43:20 +0200
In-Reply-To: <54F5C813.4030505@gmail.com> (Fred Chou's message of "Tue, 03 Mar
	2015 22:41:23 +0800")
Message-ID: <87oaoa87lj.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_154408_854581_42D66B02)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fred Chou <fred.chou.nd@gmail.com> writes:

>> Are you sure usb_control_msg() accepts vmalloc()ed buffers ?
>> 
>> My guess is the answer is no.
>> 
>> 
>
> I agree, and I would like to drop the patch. Thanks.

I dropped it from my queue.

-- 
Kalle Valo
