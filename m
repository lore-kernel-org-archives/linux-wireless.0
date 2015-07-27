Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20471 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbbG0HxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 03:53:02 -0400
Date: Mon, 27 Jul 2015 10:52:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "tony.cho" <tony.cho@atmel.com>
Cc: Chaehyun Lim <chaehyun.lim@gmail.com>, gregkh@linuxfoundation.org,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH V2 1/3] staging: wilc1000: coreconfigurator.c: remove
 WILC_MALLOC
Message-ID: <20150727075256.GB9499@mwanda> (sfid-20150727_095307_038475_1DC27F9D)
References: <1437695755-9731-1-git-send-email-chaehyun.lim@gmail.com>
 <20150724004454.GU5371@mwanda>
 <55B59D8D.6010805@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <55B59D8D.6010805@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2015년 07월 24일 09:44, Dan Carpenter wrote:
> >On Fri, Jul 24, 2015 at 08:55:53AM +0900, Chaehyun Lim wrote:
> >>Use kmalloc and kmalloc_array instead of WILC_MALLOC.
> >>
> >>Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> >>---
> >>V2: Use GFP_KERNEL flag instead of GFP_ATOMIC
> >This is probably the correct thing but how did you check that we aren't
> >holding a spin_lock or in IRQ context?

Thanks for the reply Tony, but I was really just trying to see how
Chaehyun checks his patches or if they are automatically generated.

regards,
dan carpenter

