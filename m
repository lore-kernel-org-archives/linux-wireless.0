Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:46811 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZEKIiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 04:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <4A07C905.8010805@gmail.com>
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
	 <4A074682.6010403@gmail.com>
	 <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
	 <4A07C905.8010805@gmail.com>
Date: Mon, 11 May 2009 08:38:17 +0000
Message-ID: <c6b1100b0905110138r804136aqce6111b17cabc5fb@mail.gmail.com>
Subject: Re: Oops in wireless from today's git
From: Chris Clayton <chris2553@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/11 Jiri Slaby <jirislaby@gmail.com>:
> On 05/11/2009 12:29 AM, Chris Clayton wrote:
>> 2009/5/10 Jiri Slaby <jirislaby@gmail.com>:
>>> On 05/10/2009 09:39 PM, Chris Clayton wrote:
>>>> I've just done a git pull and built, installed and booted the kern=
el.
>>>> Unfortunately I got the oops below.
>>> What's your HEAD? Looks like the issue solved by
>>> 0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
>>>
>>
>> Sorry, I'm a real novice git user, but if by HEAD you mean the lates=
t
>> commit, its a4d7749be5de4a7261bcbe3c7d96c748792ec455. The file
>> .git/FETCH_HEAD contains:
>>
>> a4d7749be5de4a7261bcbe3c7d96c748792ec455 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0branch
>> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/l=
inux-2.6
>
> Ah, I though you're on wireless-testing git. Could you try to apply t=
his
> patch?
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing=
=2Egit;a=3Dcommitdiff_plain;h=3D0cc113d866fa87c1455cbaff8d1f7ac054090bd=
5
>

Thanks Jiri. That patch applies (with offsets) and prevents the oops.
I think the patch that caused this oops was sent to stable, so  I
guess this needs pushing to Linus quite quickly so that it can go to
stable too.

Tested-by: Chris Clayton <chris2553@googlemail.com>

Thanks again.

--=20
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samue=
l
Johnson
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
