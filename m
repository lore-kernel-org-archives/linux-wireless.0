Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48200 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0LOWU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 17:20:57 -0500
Received: by wwa36 with SMTP id 36so1818476wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 14:20:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20101214T195434-788@post.gmane.org>
References: <4D07434F.6070006@tls-tautenburg.de>
	<loom.20101214T195434-788@post.gmane.org>
Date: Thu, 16 Dec 2010 00:20:55 +0200
Message-ID: <AANLkTikJHTztqvRRQVjGL_4G8Uvg-d+Zqu4q2fJZa9_i@mail.gmail.com>
Subject: Re: unresolved symbols due to missing iwlcore.ko
From: Tomas Winkler <tomasw@gmail.com>
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 14, 2010 at 9:01 PM, Bringfried Stecklum
<stecklum@tls-tautenburg.de> wrote:
> Turns out that the error is due to a fault of the configuration script. If I
> _don't_ select the iwlwifi driver via driver_select and build all drivers
> instead, iwlcore.ko will be build as well and properly installed.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

It looks like there is a mismatch between usage CONFIG_IWLWIIFI and
CONFIG_COMPAT_IWLWIFI in select script and the Makefile. I'm not sure
what is the intention so of COMPAT so I cannot say were it should be
fixed.

Thanks
Tomas
