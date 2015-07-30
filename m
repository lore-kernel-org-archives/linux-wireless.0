Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39590 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbbG3MSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 08:18:53 -0400
Date: Thu, 30 Jul 2015 15:18:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [RESEND V2 0/3] cover letter of wilc1000 patches
Message-ID: <20150730121817.GN5180@mwanda> (sfid-20150730_141929_115452_1E49233A)
References: <1438256465-19540-1-git-send-email-chaehyun.lim@gmail.com>
 <CAKV=isuiu4GeYxPFpwqSn8io-uq7hz53tiBX9dmh62b4rvRA=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKV=isuiu4GeYxPFpwqSn8io-uq7hz53tiBX9dmh62b4rvRA=g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 09:03:48PM +0900, Chaehyun Lim wrote:
> On Thu, Jul 30, 2015 at 8:41 PM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> >
> > First patch has 4 sites of kmalloc change in coreconfigurator.c
> > First one, it is used for gps8ConfigPacket at CoreconfiguratorInit and CoreConfiguratorDeInit.
> > I think it should be removed next time because I cannot find anywhere to use it.
> > Then, it is okay to change flag as GFP_KERNEL.
> >
> > Other three changes are used to handle host interface message within a kernel thread.
> > The manipulation of host interface message is not called on IRQ context and I could not
> > find any spin lock inside function.
> >

This information is good information and it should be in the patch
description.

regards,
dan carpenter

