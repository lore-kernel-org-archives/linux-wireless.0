Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab3GVOlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 10:41:04 -0400
Message-ID: <1374504059.14517.12.camel@jlt4.sipsolutions.net> (sfid-20130722_164108_399142_BEFE9603)
Subject: Re: So, which IEEE<->Frequency mappings should we be all using?
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: freebsd-wireless@freebsd.org, linux-wireless@vger.kernel.org
Date: Mon, 22 Jul 2013 16:40:59 +0200
In-Reply-To: <CAJ-Vmo=yvHUgv6pwK42n+NhPrAu9shxc5pigRkhZE+x91W_FoA@mail.gmail.com> (sfid-20130717_194238_629152_551DCEC6)
References: <CAJ-Vmo=yvHUgv6pwK42n+NhPrAu9shxc5pigRkhZE+x91W_FoA@mail.gmail.com>
	 (sfid-20130717_194238_629152_551DCEC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-17 at 10:42 -0700, Adrian Chadd wrote:

> * 420MHz
> * 700MHz
> * 900MHz (which we already have, due to history);
> * 3.6GHz
> * 4.9GHz

3.6 should have been defined in the spec recently, 4.9 surely is defined
already (though the whole stack will have to support the
dot11ChannelStartingFactor)

The others are kinda non-standard extensions, and you probably won't
even be able to properly support them since they're kinda
pretend-handled like 2.4 GHz.

johannes

