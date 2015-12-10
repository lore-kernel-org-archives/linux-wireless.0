Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35913 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbLJM2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:28:17 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?M=C3=A1rio?= Lopes <mjlopes@inesctec.pt>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Cannot unsubscribe
References: <20151210123557.3235214h30pff6vx@webmail.inescporto.pt>
Date: Thu, 10 Dec 2015 14:28:11 +0200
In-Reply-To: <20151210123557.3235214h30pff6vx@webmail.inescporto.pt>
 (=?utf-8?Q?=22M=C3=A1rio?=
	Lopes"'s message of "Thu, 10 Dec 2015 12:35:57 +0100")
Message-ID: <874mfq8p44.fsf@kamboji.qca.qualcomm.com> (sfid-20151210_132820_663089_464CBD20)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mário Lopes <mjlopes@inesctec.pt> writes:

> Our institution DNS as changed due to legal requirments, but old is
> kept active with redirection to new one. So, when I send a e-mail, it
> is sent with new DNS. Also I'm receiving e-mails that are sent to
> older (probably as with this one from mailling list) due to
> redirection. Basically I'm receiving messages from mailing list and
> when I do unsubscribe, I receive e-mail like " [...] is not a member
> of list 'linux-wireless'". I've also contacted
> linux-wireless-approval@... about this issue as told on that response,
> but no reply so far. So, how can I unsubscribe?

For the unsubcribe mail just change the From address to use your old
address, that should be easy to. And based on [1] make sure that Sender
and Reply-To headers also match.

[1] http://vger.kernel.org/majordomo-info.html

-- 
Kalle Valo
