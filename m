Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40424 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbaGWQZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 12:25:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Mike Reardon <mike.pc.reardon@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: Fwd: How to set it up, when not working
References: <CABAoMoBoBqPP9K_89E7odX8vTWkFSU_ahJ0FGjnBW3wiVz=dEQ@mail.gmail.com>
	<CABAoMoChE7jceUs=im6Vo6K2YMYSP9X4+bmj=AbqnMcrTqDgQw@mail.gmail.com>
	<8738dvysrg.fsf@kamboji.qca.qualcomm.com>
	<CABAoMoBeGX1HJa5N8FMWexUrfgY_VhkqjVWHjLYL_3oe_2ba6w@mail.gmail.com>
Date: Wed, 23 Jul 2014 19:25:39 +0300
In-Reply-To: <CABAoMoBeGX1HJa5N8FMWexUrfgY_VhkqjVWHjLYL_3oe_2ba6w@mail.gmail.com>
	(Mike Reardon's message of "Mon, 21 Jul 2014 16:11:44 -0400")
Message-ID: <87bnsgt530.fsf@kamboji.qca.qualcomm.com> (sfid-20140723_182549_941498_31D90337)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mike Reardon <mike.pc.reardon@gmail.com> writes:

> Thank you for the response.  How do I add new SDIO id to ath6kl.  I didn't
> quite catch this in link.

It's in the bug description:

https://bugzilla.kernel.org/show_bug.cgi?id=67921#c0

Just add a new entry to sdio.c.

> Will it work for my laptop specs?

I don't know, I don't have this version of board myself.

> Additionally will it work with my router. I didn't check but I'm not
> sure if it is rate for a "n" level routing.

ath6kl will work with older 11g APs as well.

-- 
Kalle Valo
