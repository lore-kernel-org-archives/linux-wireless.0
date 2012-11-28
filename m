Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62839 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2K1RqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 12:46:22 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3789621wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 09:46:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354113278.25524.28.camel@cumari.coelho.fi>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
 <1354095769-8724-2-git-send-email-arik@wizery.com> <1354113278.25524.28.camel@cumari.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 28 Nov 2012 19:46:00 +0200
Message-ID: <CA+XVXfeayZphowex+j7Ed0Mn+pWVjvKwzUntfTAQiYQ9SszL0w@mail.gmail.com> (sfid-20121128_184626_392652_F90C578C)
Subject: Re: [PATCH 01/20] wl12xx/wl18xx: update default fw logger's settings
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Reis <idor@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 4:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
>> From: Ido Reis <idor@ti.com>
>>
>> update the fw logger mode to continuous, and output to dbgpins (uart).
>>
>> Signed-off-by: Ido Reis <idor@ti.com>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> I think for upstream it's best to keep it as it was? Most people won't
> have the debug pins and won't want to get them continuously.  Sending to
> the host and only on demand seems more reasonable to me.

I think the default settings should be the ones the dev people are
using. For production a customer can (and will) change this via a
wlconf file.

I also know firsthand that the SDIO logger is pretty bad (misses
logs). The only way to get decent logging is via the dbg pins.

Arik
