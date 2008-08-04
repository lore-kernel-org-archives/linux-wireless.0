Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:37943 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbYHDJCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 05:02:23 -0400
Received: by ti-out-0910.google.com with SMTP id b6so498719tic.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 02:02:21 -0700 (PDT)
Message-ID: <a8e1da0808040202j78548d97j9962278b70d2d7d9@mail.gmail.com> (sfid-20080804_110228_118408_6F832D4C)
Date: Mon, 4 Aug 2008 17:02:20 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Pekka Enberg" <penberg@cs.helsinki.fi>, johannes@sipsolutions.net,
	tomasw@gmail.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	linville@tuxdriver.com, stable@kernel.org
In-Reply-To: <4896B89C.9060901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>
	 <4892C359.9000304@cs.helsinki.fi>
	 <20080801011415.ff4821a3.akpm@linux-foundation.org>
	 <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com>
	 <a8e1da0808032002u6ba000f8j8b56991985d65b94@mail.gmail.com>
	 <4896B89C.9060901@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 4, 2008 at 4:06 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dave Young napsal(a):
>>
>> On Fri, Aug 1, 2008 at 9:43 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>>
>>> On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org>
>>> wrote:
>>>>
>>>> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi>
>>>> wrote:
>>>>
>>>>> Jiri Slaby wrote:
>>>>>>
>>>>>> Dave Young napsal(a):
>>>>>>>
>>>>>>> In the drivers/net/wireless/ath5k/base.c, there's recursive locking
>>>>>>> of
>>>>>>> sc->lock
>>>>>>
>>>>>> Should be fixed already:
>>>>>>
>>>>>> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>>>>
>>>>> I guess that didn't make it to -stable?
>>>>
>>>> (cc stable!)
>>>
>>> Not to worry, the commit that introduced it was
>>> 9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
>>> came in after 2.6.26.
>>
>> Strange, I get system stuck in 2.6.26 as well, so there might be other
>> bugs.
>
> Could you provide any logs regarding this, please?
>

I will generate some new logs tomorrow.

There's some info in:
http://lkml.org/lkml/2008/7/29/32

-- 
Regards
dave
