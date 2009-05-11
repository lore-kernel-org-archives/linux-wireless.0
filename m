Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:64910 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZEKIp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 04:45:57 -0400
Message-ID: <4A07E5C7.5030000@gmail.com>
Date: Mon, 11 May 2009 10:45:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops in wireless from today's git
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>	 <4A074682.6010403@gmail.com>	 <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>	 <4A07C905.8010805@gmail.com> <c6b1100b0905110138r804136aqce6111b17cabc5fb@mail.gmail.com>
In-Reply-To: <c6b1100b0905110138r804136aqce6111b17cabc5fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2009 10:38 AM, Chris Clayton wrote:
> Thanks Jiri. That patch applies (with offsets) and prevents the oops.
> I think the patch that caused this oops was sent to stable, so  I
> guess this needs pushing to Linus quite quickly so that it can go to
> stable too.

Yes, you're right, it now oopses with cards that support only one 802.11
band, but it's still better than silently corrupting memory. Of course,
the oops-fixing patch should be merged into the stable aswell.

Thanks for testing.
