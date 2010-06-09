Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37017 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757784Ab0FINpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 09:45:09 -0400
Date: Wed, 9 Jun 2010 09:42:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jaroslav Fojtik <jafojtik@seznam.cz>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Compilation problems with Linux-2.6.34 and
 compat-wireless-2010-06-05
Message-ID: <20100609134234.GA2452@tuxdriver.com>
References: <4C0F399A.21017.1F03DB8@jafojtik.seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C0F399A.21017.1F03DB8@jafojtik.seznam.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 09, 2010 at 08:50:02AM +0200, Jaroslav Fojtik wrote:
> Dears,
> 
> could you fix this compilation problem:
> 
> make -C /usr/src/linux-2.6.34 M=/I/USR_SRC/compat-wireless-2010-06-05 modules
> make[1]: Entering directory `/I/USR_SRC/linux-2.6.34'
>   CC [M]  /I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.o
> /I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c: In function 
> 'ipw2100_alloc_device':
> /I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:6138: error: 
> 'struct net_device' has no member named 'wireless_handlers'
> /I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:6144: error: 
> 'struct net_device' has no member named 'wireless_data'

I'm guessing you need CONFIG_WIRELESS_EXT in /usr/src/linux-2.6.34/.config ?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
