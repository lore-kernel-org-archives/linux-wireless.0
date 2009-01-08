Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38705 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZAHSKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:10:42 -0500
Date: Thu, 8 Jan 2009 18:10:35 +0000
From: Andrew Price <andy@andrewprice.me.uk>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: Fix radio LED type check
Message-ID: <20090108181035.GA27377@silver.sucs.org> (sfid-20090108_191047_135311_AB4C8F61)
References: <20090102080527.GA16585@silver.sucs.org> <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 02, 2009 at 12:14:17PM +0100, Ivo Van Doorn wrote:
> On Fri, Jan 2, 2009 at 9:05 AM, Andrew Price <andy@andrewprice.me.uk> wrote:
> > Since commit 9a95dba32735534bda59def40c747bf606fedf05 "rt2x00: Fix LED
> > state handling", rt2x00leds_led_radio wrongly checks that the LED type
> > is LED_TYPE_ASSOC. This patch makes it check for LED_TYPE_RADIO once
> > again.
> >
> > Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
> 
> Good catch. Thanks.
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Thanks for that. I'm a little new to this so I'm not sure what happens now.
Will the patch go into John's tree and make it's way to Linus' tree (where the
bug is) or should I send it directly to Linus/LKML with Ivo's Acked-by line?

Regards,

--
Andrew Price
