Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61659 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab1EUAFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 20:05:33 -0400
Received: by vws1 with SMTP id 1so3029516vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 17:05:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305917949.4640.16.camel@jlt3.sipsolutions.net>
References: <1305917869.4640.15.camel@jlt3.sipsolutions.net> <1305917949.4640.16.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 20 May 2011 17:05:12 -0700
Message-ID: <BANLkTikjDhdYMssyivgRxAyB5-_FctQbSg@mail.gmail.com> (sfid-20110521_020538_123604_164F25AB)
Subject: Re: netlink reverts
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 20, 2011 at 11:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-05-20 at 11:57 -0700, Johannes Berg wrote:
>> John,
>>
>> Please revert
>> 9c3990aaec0ad9f686ef6480f6861f2df89b2a7a
>> ASAP; you'll have to revert
>> 8958da779b92da60e90d9761549b88677a6a3eef
>> first. (alternatively, if you're feeling less pissed off than I am you
>> can fix it I guess)
>>
>> Javier fucked up the netlink attribute types again by inserting
>> something in the middle, and I'm really mad about it too.
>
> Hmm, maybe I shot first and then asked questions ;-) Looking at it again
> it _might_ have been introduced by merge issues?

Don't shoot me, please, it really _was_ a merge issue.  My patch did
not insert anything in the middle:
https://patchwork.kernel.org/patch/752292  and it was sent a day
before you sent the patch adding WoWLAN support:
https://patchwork.kernel.org/patch/753772/

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
