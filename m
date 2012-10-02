Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2JBSlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 14:41:03 -0400
Message-ID: <1349203294.10698.25.camel@jlt4.sipsolutions.net> (sfid-20121002_204119_585344_A62D5C00)
Subject: Re: Bug#684352: phy0/hp-wifi problems after kernel update from 2.6
 to 3.2
From: Johannes Berg <johannes@sipsolutions.net>
To: David Smith <sidicas2@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 02 Oct 2012 20:41:34 +0200
In-Reply-To: <CA+7qwUksJykOMW1gOq4g+9kyv6R0Tb_fx9Lkuikss37V1-EPTg@mail.gmail.com> (sfid-20121002_203720_153266_D0AF5DDE)
References: <CA+7qwUkZiysOF-ocV+wyTGfnFyiGH6G=TiEB+ts89Pb=NvgpxA@mail.gmail.com>
	 <CA+7qwUksJykOMW1gOq4g+9kyv6R0Tb_fx9Lkuikss37V1-EPTg@mail.gmail.com>
	 (sfid-20121002_203720_153266_D0AF5DDE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-03 at 02:37 +0800, David Smith wrote:
> Trying again to send this to  linux-wireless@vger.kernel.org.
> Previously blocked because gmail put some html in there.
> 
> Please CC:  Anssi Hannula <anssi.hannula@iki.fi>,
> 684352@bugs.debian.org, sidicas2@gmail.com  on replies.

> Hello, I'm having a problem with my Intel 2200 wireless on my Compaq
> Presario V4000T (made by HP) that has started happening after I
> upgraded my kernel from 2.6 to 3.2.
> 
> Problem: phy0 wireless state is incorrect.

> After many many hours of searching, I discovered that running "rfkill
> unblock all" is able to remove the "Hard Block" from phy0 and put the
> wireless into this state:

Since you can fix it that way, it must be a bug with the HP platform
driver, so there's nothing we can do about it on the linux-wireless
list, sorry. You might want to bisect the platform drivers to see which
change caused this.

johannes

