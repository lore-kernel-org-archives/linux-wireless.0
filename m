Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33544 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbKHPRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 10:17:01 -0500
MIME-Version: 1.0
In-Reply-To: <20151107205101.GK18797@mwanda>
References: <1446895909-30052-1-git-send-email-punitvara@gmail.com>
	<20151107135427.GH18797@mwanda>
	<CABXAfNJWe78txO91YixoEZTO1n7q69LqN89UpDanrT8cA-jnyA@mail.gmail.com>
	<20151107205101.GK18797@mwanda>
Date: Sun, 8 Nov 2015 20:47:00 +0530
Message-ID: <CABXAfNJCcw0G9BM_mT6SLXxDjE6ifhM-AsVt6fy8WUE7eX4=3A@mail.gmail.com> (sfid-20151108_161744_289366_1EB3B4FE)
Subject: Re: [PATCH] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
From: punit vara <punitvara@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2015 at 2:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I haven't looked at it, sorry.  You'll have to figure it out or if you
> complain to the original person who broken the build he can figure it
> out.  You are still missing a Fixes tag.
>
> regards,
> dan carpenter
Actually while building one of my another patch I have found this
broken. Now I understand what tag is . Would you tell me how can I
find that particular commit which create defeat in this file ? Sorry
first time I have encounter this kind of problem so I do not know how
to figure it out.
