Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56254 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab0KVSOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:14:37 -0500
Received: by qyk11 with SMTP id 11so517215qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 10:14:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimGO=HH4nxgmCidXfGcLdwnkYQxr+i10eNzefgH@mail.gmail.com>
References: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
	<1290389406-29852-1-git-send-email-lacombar@gmail.com>
	<AANLkTimGO=HH4nxgmCidXfGcLdwnkYQxr+i10eNzefgH@mail.gmail.com>
Date: Mon, 22 Nov 2010 13:14:36 -0500
Message-ID: <AANLkTiktEvmbf6aowk+ZX+SFh0AOE6nsFrtxDLQErV4z@mail.gmail.com>
Subject: Re: [PATCH] compat/2.6.22: limit namespace pollution
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Nov 22, 2010 at 1:01 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Sun, Nov 21, 2010 at 5:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>
> Was this test compiled on all supported kernels?
>
I am using this internally for all kernels (.15 -> .36). Beside that,
I should still test-build the full compat module. Fixes might be
needed.

What is the "official" range of supported kernels ? AFAIR, at some
point, very old kernel are not included by <linux/compat.h>. Do you
know a module I can use to test regressions, other than my use-case ?

 - Arnaud
