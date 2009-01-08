Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35352 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbZAHStt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:49:49 -0500
Received: by ewy10 with SMTP id 10so9791424ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 10:49:47 -0800 (PST)
To: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: [PATCH] rt2x00: Fix radio LED type check
Date: Thu, 8 Jan 2009 19:49:43 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20090102080527.GA16585@silver.sucs.org> <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com> <20090108181035.GA27377@silver.sucs.org>
In-Reply-To: <20090108181035.GA27377@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901081949.43463.IvDoorn@gmail.com> (sfid-20090108_194953_036566_E75D65BF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 January 2009, Andrew Price wrote:
> On Fri, Jan 02, 2009 at 12:14:17PM +0100, Ivo Van Doorn wrote:
> > On Fri, Jan 2, 2009 at 9:05 AM, Andrew Price <andy@andrewprice.me.uk> wrote:
> > > Since commit 9a95dba32735534bda59def40c747bf606fedf05 "rt2x00: Fix LED
> > > state handling", rt2x00leds_led_radio wrongly checks that the LED type
> > > is LED_TYPE_ASSOC. This patch makes it check for LED_TYPE_RADIO once
> > > again.
> > >
> > > Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
> > 
> > Good catch. Thanks.
> > 
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Thanks for that. I'm a little new to this so I'm not sure what happens now.
> Will the patch go into John's tree and make it's way to Linus' tree (where the
> bug is) or should I send it directly to Linus/LKML with Ivo's Acked-by line?

I had added John to the CC list in my initial reply to notify him of the patch,
he will pick up the patch and make sure it will make its way to Linus. :)

Ivo
