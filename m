Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:11279 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZEKGnf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 02:43:35 -0400
Message-ID: <4A07C905.8010805@gmail.com>
Date: Mon, 11 May 2009 08:43:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops in wireless from today's git
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>	 <4A074682.6010403@gmail.com> <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
In-Reply-To: <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2009 12:29 AM, Chris Clayton wrote:
> 2009/5/10 Jiri Slaby <jirislaby@gmail.com>:
>> On 05/10/2009 09:39 PM, Chris Clayton wrote:
>>> I've just done a git pull and built, installed and booted the kernel.
>>> Unfortunately I got the oops below.
>> What's your HEAD? Looks like the issue solved by
>> 0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
>>
> 
> Sorry, I'm a real novice git user, but if by HEAD you mean the latest
> commit, its a4d7749be5de4a7261bcbe3c7d96c748792ec455. The file
> .git/FETCH_HEAD contains:
> 
> a4d7749be5de4a7261bcbe3c7d96c748792ec455                branch
> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

Ah, I though you're on wireless-testing git. Could you try to apply this
patch?
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff_plain;h=0cc113d866fa87c1455cbaff8d1f7ac054090bd5
