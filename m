Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44059 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2LCWcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 17:32:06 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so2116778vby.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 14:32:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201212011531.25832.chunkeey@googlemail.com>
References: <CAJ-VmomxqY4FbzRSXtXTgUbVJOSwTJJAF953UO0xN275pPTJLg@mail.gmail.com>
	<201212011531.25832.chunkeey@googlemail.com>
Date: Mon, 3 Dec 2012 14:32:03 -0800
Message-ID: <CAJ-Vmo=C1UFZ3H2JUi4eq5VBidFeutvTYqswc7YSiuq6DZ-2AA@mail.gmail.com> (sfid-20121203_233210_665424_C639AF81)
Subject: Re: ath9k_htc test release: please test
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2012 06:31, Christian Lamparter <chunkeey@googlemail.com> wrote:

>> Please let me know if it works or doesn't work for you.
>
> Thanks! It seems to work/hold.

Thanks!

> Can you please bump the version
>
> old:
> [   26.106713] ath9k_htc 1-10:1.0: ath9k_htc: FW Version: 1.3
> new:
> [16308.270828] ath9k_htc 1-10:1.0: ath9k_htc: FW Version: 1.3

I'll bump the firmware version when it's time to do a release. I'll
see how difficult it'll be to have a development/snapshot and a
release version number scheme too.




Adrian
