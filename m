Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51301 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLDFWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 00:22:19 -0500
Message-ID: <4B189C94.4080404@gmail.com>
Date: Thu, 03 Dec 2009 21:22:28 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Miles Lane <miles.lane@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] BUG kmalloc-8192: Poison overwritten
References: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com> 	<43e72e890912021516k736db118j217dc92496db8f19@mail.gmail.com> 	<4B182F79.7060103@gmail.com> <43e72e890912031345m3f5adb9nca754e33a858c923@mail.gmail.com>
In-Reply-To: <43e72e890912031345m3f5adb9nca754e33a858c923@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/09 13:45, Luis R. Rodriguez wrote:


> I think waiting to be able to reproduce is best, and appreciate your
> patience on this. Maybe Miles Lanes also cannot reproduce easily and
> that may explain why he hasn't replied.
>
>    Luis
>

o.k., did some more experimenting
but came up with something other than
what I was hoping for(something with s2ram),
Anyways the two patches applied clean,
I'll just run  the system with these in,
and if somebody comes along with more expertise
on this I can try their advice(or if I somehow find
a way to reproduce this).

Justin P. Mattock
