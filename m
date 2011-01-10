Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38102
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab1AJIGS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 03:06:18 -0500
Date: Mon, 10 Jan 2011 00:06:50 -0800 (PST)
Message-Id: <20110110.000650.124002380.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, alex.arnautu96@gmail.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Kernel 2.6.37-rc5 rc7 Oops
From: David Miller <davem@davemloft.net>
In-Reply-To: <1293652965.7150.13.camel@edumazet-laptop>
References: <AANLkTinCD5Jf-dEUpv7hu4YKrxS0DGqqqBU94iCJ8602@mail.gmail.com>
	<AANLkTinJAEW-xAiEKnfxo1+3FiGwFXFii5Rh6d8tAtB-@mail.gmail.com>
	<1293652965.7150.13.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 29 Dec 2010 21:02:45 +0100

> Le mercredi 29 décembre 2010 à 11:23 -0800, Linus Torvalds a écrit :
>> On Wed, Dec 29, 2010 at 4:26 AM, Alex Arnautu <alex.arnautu96@gmail.com> wrote:
>> >
>> > I get an oops with 2.6.37-rc5 and 2.6.37-rc7-git1.
>> > http://www.fotoshack.us/fotos/19044P271210_15.14_[01].jpg
>> 
>> Hmm. Davem added to the list of people involved. This _may_ be fixed
>> by the "always clone skbs" commit in -rc8 (commit 173021072), but
>> David can make a better judgment call.
>> 
> 
> Very unlikely, as commit 173021072 only fix a bug in case mirred is
> used.

This should be taken to the wireless list (now CC:'d) as the rt2xxx
driver and the wireless stack are both in that backtrace.
