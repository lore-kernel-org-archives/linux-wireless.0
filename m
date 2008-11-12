Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYKLR7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 12:59:34 -0500
Subject: Re: libertas_tf should replace libertas_usb on compat-wireless?
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1226505205.13536.13.camel@localhost.localdomain>
References: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com>
	 <1226505205.13536.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 12:57:29 -0500
Message-Id: <1226512649.3940.0.camel@localhost.localdomain> (sfid-20081112_185954_492359_E7A1CE1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-12 at 10:53 -0500, Dan Williams wrote:
> On Tue, 2008-11-11 at 16:32 -0800, Luis R. Rodriguez wrote:
> > By default do we want users of compat-wireless to get libertas_usb or
> > libertas_tf? Both drivers are for Marvell Libertas 8388 USB 802.11b/g
> > cards so we need to pick one.
> 
> I think libertas_tf is still experimental at this time.  Louis could
> elaborate more.

And that would be Luis (luisca) not Louis.  Sorry Luis! :)

Dan


