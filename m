Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:50584 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZEJV0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 May 2009 17:26:42 -0400
Message-ID: <4A074682.6010403@gmail.com>
Date: Sun, 10 May 2009 23:26:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Oops in wireless from today's git
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
In-Reply-To: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2009 09:39 PM, Chris Clayton wrote:
> I've just done a git pull and built, installed and booted the kernel.
> Unfortunately I got the oops below.

What's your HEAD? Looks like the issue solved by
0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
