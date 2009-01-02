Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44173 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZABOKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 09:10:17 -0500
Subject: Re: [PATCH] rt2x00: Fix radio LED type check
From: Marcel Holtmann <marcel@holtmann.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Andrew Price <andy@andrewprice.me.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com>
References: <20090102080527.GA16585@silver.sucs.org>
	 <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 15:10:14 +0100
Message-Id: <1230905414.15391.39.camel@californication> (sfid-20090102_151023_427303_FD8BAAD7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ivo,

> > Since commit 9a95dba32735534bda59def40c747bf606fedf05 "rt2x00: Fix LED
> > state handling", rt2x00leds_led_radio wrongly checks that the LED type
> > is LED_TYPE_ASSOC. This patch makes it check for LED_TYPE_RADIO once
> > again.
> >
> > Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
> 
> Good catch. Thanks.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

small comment from my side here. Signed-off-by is only suppose to be
used if you pick up the patch and then send it to John by yourself. If
you just wanna indicate that it is fine for John to pick up this patch,
then it should be an Acked-by: line.

The Signed-off-by should indicate the steps (aka persons) this patch
when through until it reached Linus. This doesn't include people testing
or acknowledging a patch.

Regards

Marcel


