Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:18786 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbYKLVQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:16:38 -0500
Received: by qw-out-2122.google.com with SMTP id 3so360270qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 13:16:37 -0800 (PST)
Message-ID: <69e28c910811121316i285ec2dbr7acf6c3fe660536a@mail.gmail.com> (sfid-20081112_221642_623918_8FF331D5)
Date: Wed, 12 Nov 2008 22:16:36 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: libertas_tf should replace libertas_usb on compat-wireless?
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"David Woodhouse" <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <45e8e6c40811121307v32ca4c2cq77714ff14bec4563@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com>
	 <1226505205.13536.13.camel@localhost.localdomain>
	 <1226512649.3940.0.camel@localhost.localdomain>
	 <20081112195515.GA15803@tesla>
	 <45e8e6c40811121307v32ca4c2cq77714ff14bec4563@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 12, 2008 at 10:07 PM, Andrey Yurovsky <andrey@cozybit.com> wrote:
> libertas_tf is a softmac driver developed mainly so that XO's can run
> hostapd and the like.  libertas is the general (fullmac) driver and,
> in my opinion, should be the one users get unless they specifically
> wanted libertas_tf because they're experimenting with AP mode or other
> mac80211 features.  So I guess I'd vote for libertas over libertas_tf
> at this time, for what it's worth.
>
>  -Andrey

I think libertas_usb should be a default (as it's HW accelerated), but
libertas_tf should be included as an option (disabled by default in
config.mk, or auto-added to /etc/modprobe.d/blacklist upon make
install).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
