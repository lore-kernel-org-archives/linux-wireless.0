Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39651 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965309AbcAURMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 12:12:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Paul McQuade <paulmcquad@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wireless: rt2x00: Fixed Spacing issues
References: <1445112279-27796-1-git-send-email-paulmcquad@gmail.com>
	<CAGXE3d-nbDGOgxGiasPixtiUhNtWZ+C7AgV3zMQAo1JN9KgbNw@mail.gmail.com>
	<CAGXE3d-3M6s0k0rbA2-vihLfwvjhdVgxDsQSt_84WxXme+U7bg@mail.gmail.com>
Date: Thu, 21 Jan 2016 19:12:34 +0200
In-Reply-To: <CAGXE3d-3M6s0k0rbA2-vihLfwvjhdVgxDsQSt_84WxXme+U7bg@mail.gmail.com>
	(Helmut Schaa's message of "Thu, 21 Jan 2016 18:02:45 +0100")
Message-ID: <87oaceyhz1.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_181257_198735_F14986E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> On Thu, Jan 21, 2016 at 5:56 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
>> On Sat, Oct 17, 2015 at 10:04 PM, Paul McQuade <paulmcquad@gmail.com> wrote:
>>> Removed empty spaces before/after parenthesis
>>>
>>> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
>>
>> Just noticed these did not get applied by Kalle yet.
>
> Kalle, can you fix up the path (ralink/rt2x00 instead of rt2x00) when applying?
> Or would you prefer Paul to respin the whole code style cleanup series?

Actually git should be manage that automatically, it's so awesome :)

I can also fix the title and remove the unnecessary "net: wireless:"
prefix.


-- 
Kalle Valo
