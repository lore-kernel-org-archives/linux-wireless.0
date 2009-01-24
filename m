Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:62204 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZAXQEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 11:04:34 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1364646rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 08:04:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <45e8e6c40901231106t481c823ag3bbac67d8205ef7a@mail.gmail.com>
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <45e8e6c40901231106t481c823ag3bbac67d8205ef7a@mail.gmail.com>
Date: Sat, 24 Jan 2009 16:04:31 +0000
Message-ID: <e27b78a40901240804m1acd3a83o7bf6d01f81ec3397@mail.gmail.com> (sfid-20090124_170439_365143_19B7351B)
Subject: Re: Crashing on ping?
From: Keir <keirlawson@gmail.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tried that commit, still no luck :( It consistently freezes up on
ping, though sometimes it's the machine doing the pining, and other
times it's the machine being pinged.  Wondering what I can do to help
debug this?

Keir

2009/1/23 Andrey Yurovsky <andrey@cozybit.com>:
> Hi Keir.  Incidentally, we're using ath5k mesh right now at commit
> 93bd2ac7301b0879821e584991f82de372d62bf6 (that's just after the
> 2.6.29-rc1 tag but before -rc2) an things work fine.  I haven't had a
> chance to try head of wireless-testing this week.
>
>  -Andrey
>
> On Fri, Jan 23, 2009 at 8:03 AM, Keir <keirlawson@gmail.com> wrote:
>> I just pulled the latest wireless-testing kernel, however, much like
>> the previous wireless-testing kernel I was working on, when attempting
>> to ping one node from another on a mesh, using ath5k, the node
>> attempting to ping completely freezes after about 7 pings are
>> (succesfully) sent.  Anyone have any idea what is going wrong here?
>>
>> Cheers
>>
>> Keir
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
