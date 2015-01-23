Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48647 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbAWPjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 10:39:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andy Green <andy.green@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/7] net: wireless: wcn36xx: add wcn3620 chip type definition
References: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net>
	<20150118051043.31866.53087.stgit@114-36-241-182.dynamic.hinet.net>
	<878uh06ulp.fsf@kamboji.qca.qualcomm.com>
	<CAAfg0W4cns51+B_imf1jGWOmA0S8jqNFR+6epRxv8qqTgvBAgg@mail.gmail.com>
Date: Fri, 23 Jan 2015 17:39:40 +0200
In-Reply-To: <CAAfg0W4cns51+B_imf1jGWOmA0S8jqNFR+6epRxv8qqTgvBAgg@mail.gmail.com>
	(Andy Green's message of "Mon, 19 Jan 2015 08:24:41 +0800")
Message-ID: <87twzhld4z.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_163954_053256_001D483C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green <andy.green@linaro.org> writes:

> On 18 January 2015 at 22:17, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Andy Green <andy.green@linaro.org> writes:
n>>
>>> Convert the list of chip types to an enum, add the default
>>> UNKNOWN type and a type for WCN3620 chip
>>>
>>> Signed-off-by: Andy Green <andy.green@linaro.org>
>>
>> Please just use "wcn36xx: ", you should drop "net: wireless: " entirely.
>
> OK.
>
> Can you help me understand what you'd like to see happen with the chip
> variant detection stuff?

I haven't looked at wcn36xx for a long time so I'm not really the right
person to answer. I'm more like a desk jockey now ;)

> There's a comment sent to one list only saying it might be preferable
> to keep the old detection code as the default.  But there are no
> in-tree users of wcn36xx (mainly due to PIL not being in mainline, I
> guess).
>
> The old test's equivalence that AC == 3680 seems kind of weak to me
> and establishing the type must be passed in from platform code
> reflects the situation that there's no public way to detect the chip
> type from Qualcomm.  In the second not-for-upstream series I use that
> to pass it in from DT, which is how it'd be normally used.

Please remember that the DT bindings document has to be acked by the
device-tree maintainers.

-- 
Kalle Valo
