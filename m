Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33711 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab0EJTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 15:00:13 -0400
Date: Mon, 10 May 2010 14:58:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] wireless: depends on NET
Message-ID: <20100510185802.GD11681@tuxdriver.com>
References: <20100510092429.a8ddcc8d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100510092429.a8ddcc8d.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 10, 2010 at 09:24:29AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_NET is disabled, the attempt to build wext-priv.c
> fails with:
> 
> net/wireless/wext-priv.c: In function 'ioctl_private_call':
> net/wireless/wext-priv.c:207: error: implicit declaration of function 'call_commit_handler'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> Has this been omitted on purpose??

I doubt it...thanks for the patch!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
