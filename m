Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:49576 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZABOV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 09:21:28 -0500
Received: by ewy10 with SMTP id 10so6769715ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 06:21:25 -0800 (PST)
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] rt2x00: Fix radio LED type check
Date: Fri, 2 Jan 2009 15:21:20 +0100
Cc: Andrew Price <andy@andrewprice.me.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20090102080527.GA16585@silver.sucs.org> <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com> <1230905414.15391.39.camel@californication>
In-Reply-To: <1230905414.15391.39.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901021521.20500.IvDoorn@gmail.com> (sfid-20090102_152131_642571_4E6F9806)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 January 2009, Marcel Holtmann wrote:
> Hi Ivo,
> 
> > > Since commit 9a95dba32735534bda59def40c747bf606fedf05 "rt2x00: Fix LED
> > > state handling", rt2x00leds_led_radio wrongly checks that the LED type
> > > is LED_TYPE_ASSOC. This patch makes it check for LED_TYPE_RADIO once
> > > again.
> > >
> > > Signed-off-by: Andrew Price <andy@andrewprice.me.uk>
> > 
> > Good catch. Thanks.
> > 
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> small comment from my side here. Signed-off-by is only suppose to be
> used if you pick up the patch and then send it to John by yourself. If
> you just wanna indicate that it is fine for John to pick up this patch,
> then it should be an Acked-by: line.
> 
> The Signed-off-by should indicate the steps (aka persons) this patch
> when through until it reached Linus. This doesn't include people testing
> or acknowledging a patch.

Ok, feel free to change it to a Acked-by then. ;)

Ivo

