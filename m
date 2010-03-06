Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab0CFGfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 01:35:24 -0500
Subject: Re: Mesh support for gumstix's wireless (Marvell 88W8385 wireless
 chip with CF interface)
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <yurovsky@gmail.com>
Cc: Darko Makreshanski <d.makreshanski@jacobs-university.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <c1545bb51003041638v28e5fe9me336735fc940e1ea@mail.gmail.com>
References: <4B9024DE.308@jacobs-university.de>
	 <c1545bb51003041638v28e5fe9me336735fc940e1ea@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 22:35:49 -0800
Message-ID: <1267857349.2243.158.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-04 at 16:38 -0800, Andrey Yurovsky wrote:
> On Thu, Mar 4, 2010 at 1:23 PM, Darko Makreshanski
> <d.makreshanski@jacobs-university.de> wrote:
> > 1. will mesh networking work with the 88W8385 chip on gumstix with the
> > libertas driver?
> 
> No.  The OLPC uses an 88w8288 with in-firmware mesh on the USB
> variant.  That firmware won't run on other chips.

I assume you mean 88w8388 :)

Dan

> > 3. if not, is it possible to make the libertas_tf driver work with this
> > chip?
> 
> No.  That driver only supports the 88w8388 USB variant with special
> firmware.  Your chip is a full-MAC device and therefore cannot use the
> mac80211 mesh stack (and there isn't a special firmware to make it do
> something else).
> 
>   -Andrey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


