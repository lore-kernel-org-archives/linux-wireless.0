Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47566 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752481Ab2BUVLS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 16:11:18 -0500
Message-ID: <1329858675.5143.13.camel@joe2Laptop> (sfid-20120221_221138_177318_7CF4CAF5)
Subject: Re: [PATCH] checkpatch: Add some --strict coding style checks
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
	Andy Whitcroft <apw@shadowen.org>,
	andrei.emeltchenko.news@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 21 Feb 2012 13:11:15 -0800
In-Reply-To: <20120221130917.e41491d4.akpm@linux-foundation.org>
References: <20120221151435.GA19354@tuxdriver.com>
	 <20120221.144417.1445117001833888214.davem@davemloft.net>
	 <CAMXE1-qB8_5oGey2=Ypa5BitZnye3YqdM=yB8oKCGLvoZu_8HQ@mail.gmail.com>
	 <20120221.154053.2103818562080068513.davem@davemloft.net>
	 <1329857959.5143.11.camel@joe2Laptop>
	 <20120221130917.e41491d4.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-21 at 13:09 -0800, Andrew Morton wrote:
> Speaking of which, I just got this:
> 
> WARNING: %Ld/%Lu are not-standard C, use %lld/%llu
> #142: FILE: fs/locks.c:2335:
> +                       seq_printf(f, "Start-end:\t %Ld-EOF\n\n", fl->fl_start);
> 
> But %L saves a byte!  Why did we do this?  Don't you like puppies?

Beats me and I prefer kittens.

