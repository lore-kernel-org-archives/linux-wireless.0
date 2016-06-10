Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42617 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbcFJM5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 08:57:37 -0400
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
To: Ben Greear <greearb@candelatech.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru>
 <CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com>
 <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name>
 <877fdxfd2l.fsf@kamboji.qca.qualcomm.com> <575AB829.10101@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org, "A. Benz" <ash.benz@bk.ru>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f80db123-9b8a-289d-aed8-12531db13424@nbd.name> (sfid-20160610_145741_255162_7ED4AF46)
Date: Fri, 10 Jun 2016 14:57:27 +0200
MIME-Version: 1.0
In-Reply-To: <575AB829.10101@candelatech.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-10 14:52, Ben Greear wrote:
> This looks a lot like the problems I was having.
> 
> Two of these 5 patches recently made it upstream (but may not be in LEDE yet),
> but the other patches also were related to memory corruption.
> 
> See my patches posted on 4/1/16:
> 
> https://patchwork.kernel.org/project/ath10k/list/
> 
> I don't know where the 5/5 patch ended up.
I had already asked affected users to test with those patches (I have a
commit that adds them in my staging tree), but it did not resolve the issue.

- Felix
