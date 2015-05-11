Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41689 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbbEKR4X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 13:56:23 -0400
Message-ID: <5550ED39.1040204@openwrt.org> (sfid-20150511_195721_869573_BCC1E8B9)
Date: Mon, 11 May 2015 19:56:09 +0200
From: Jonas Gorski <jogo@openwrt.org>
MIME-Version: 1.0
To: Okash Khawaja <okash.khawaja@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"joe@perches.com" <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] adm8211: fix the possible pci cache line sizes inside
 switch-case
References: <20150505224020.GA3805@bytefire-computer> <87wq0ms3mv.fsf@kamboji.qca.qualcomm.com> <20150506063241.GA3042@bytefire-computer> <87k2wflj7p.fsf@kamboji.qca.qualcomm.com> <2CBE2DDF-92E5-45C9-95F8-C5CF918D12D9@gmail.com> <87vbfzjt4t.fsf@kamboji.qca.qualcomm.com> <CAOiHx=kzSsFenqPSNeAX6P5wJK8Hr-q+s+rJoQQMPbSGmE50xw@mail.gmail.com> <4C95B6D2-3A68-4360-BE3C-5264DD0ED8DF@gmail.com>
In-Reply-To: <4C95B6D2-3A68-4360-BE3C-5264DD0ED8DF@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11.05.2015 19:48, Okash Khawaja wrote:
>> On 11 May 2015, at 14:24, Jonas Gorski <jogo@openwrt.org> wrote:
>>
>> Hi,
>>
>>> On Mon, May 11, 2015 at 12:38 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Okash Khawaja <okash.khawaja@gmail.com> writes:
>>>
>>>> Sure, I'll create v2 of the patch with updated commit log.
>>>>
>>>> Since it's part of a patch set, do you want me to send both the
>>>> patches in the patch set together as v2 or just this patch?
>>>
>>> Please resend the whole patchset as v2, less problems that way.
>>
>> If you are sending a v2 anyway, I'd suggest using decimal values for
>> the cases, as cache line sizes are usually given in decimal anyway. So
>> just drop the "0x" instead of converting the values ;-)
>>
>>
>> Jonas
> 
> Jonas, I had already sent the updated patch by the time I received your email. Is there a convention around this?

You did everything right, just gmail decided "helpfully" they were spam,
so I didn't see that you already sent the v2.

So ingore my comment unless you need to send a v3. It's only a minor
nitpick but nothing respin-worthy IMHO.


Jonas
