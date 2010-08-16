Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46641 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0HPTcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 15:32:48 -0400
Received: by qyk29 with SMTP id 29so2265497qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 12:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C6991D9.7070902@lwfinger.net>
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
 <4C698C19.5010902@lwfinger.net> <AANLkTi=eFz5fabN74xbndCvD-XBS-KA9EBiOKAZvcbRb@mail.gmail.com>
 <4C6991D9.7070902@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 16 Aug 2010 21:32:26 +0200
Message-ID: <AANLkTikBHTX_8SWBwUQBOpL2DOxriPKLX+eQmPPO+a1Y@mail.gmail.com>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/8/16 Larry Finger <Larry.Finger@lwfinger.net>:
> On 08/16/2010 02:16 PM, Gábor Stefanik wrote:
>>
>> Oops... yes, two nasty typos. I have no idea why it compiled for me...
>> Schrödinbug?
>>
>> With that said, here is the corrected version.
>
> Hmmm, a new application of the "Uncertainty Principle".
>
> The patch did not break my 14e4:4315 device, which already worked.
>
> Larry
>

That's expected, given that the hybrid driver also does this. :-) The
question is whether it fixes the DMA error.
