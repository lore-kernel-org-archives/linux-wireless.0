Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:35380 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbcCHOBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 09:01:47 -0500
MIME-Version: 1.0
In-Reply-To: <CA+A7VXWWQOti7pOre08QcXN9vgssQH3V1f6RjphaK0VwM27C7g@mail.gmail.com>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
 <1456159001-20307-9-git-send-email-jprvita@endlessm.com> <20160226175925.GA9331@w1.fi>
 <CA+A7VXUY=qVDQ-OqT+QJK8haN6AFX4Br=OPXi-6RCxpvH3=QRg@mail.gmail.com>
 <20160229223918.GA32464@w1.fi> <1456839787.3926.20.camel@sipsolutions.net> <CA+A7VXWWQOti7pOre08QcXN9vgssQH3V1f6RjphaK0VwM27C7g@mail.gmail.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Tue, 8 Mar 2016 09:01:06 -0500
Message-ID: <CA+A7VXXd0SONVPi2BOokL13YevR0+hmFz4KE-U1MvXT0qqWN_A@mail.gmail.com> (sfid-20160308_150217_531958_8232D696)
Subject: Re: [PATCHv2 08/10] rfkill: Use switch to demux userspace operations
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

On 1 March 2016 at 11:15, João Paulo Rechi Vita <jprvita@gmail.com> wrote:
> On 1 March 2016 at 08:43, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>> I'm fine with Jouni's change, preserving the original behaviour of
>> requiring TYPE_ALL or the correct type, but I'm tempted to simply
>> remove the type check entirely.
>>
>> Thoughts?
>>
>
> I think this patch should keep the original logic, as this is supposed
> to be a refactor only. If we decide to remove the check, we should to
> it in a separate patch, to make it clear for someone looking at the
> history later.
>
> I'm fine with removing the type check (in a separate patch), but I
> don't see much gain in doing so.
>

I just saw you picked this patch with Jouni's fix, thanks!

--
João Paulo Rechi Vita
http://about.me/jprvita
