Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:38813 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYGVNlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 09:41:49 -0400
Received: by an-out-0708.google.com with SMTP id d40so442280and.103
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 06:41:48 -0700 (PDT)
Message-ID: <43e72e890807220641y7368f818h20f2410ce449a76b@mail.gmail.com> (sfid-20080722_154153_127419_3F3BC7CC)
Date: Tue, 22 Jul 2008 06:41:48 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Maarten Wisse" <WisseAanen@gmx.de>
Subject: Re: No led with compat-20080721 and iwl3945
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200807220833.54383.WisseAanen@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200807220833.54383.WisseAanen@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 11:33 PM, Maarten Wisse <WisseAanen@gmx.de> wrote:
> Dear wireless developers,
>
> You might know it already, but the led doesn't blink anymore in iwl3945, on a
> dell D620 with a gentoo 2.6.25-tuxonice-r6 kernel with compat-20080721
> installed. The connection seems quite stable though. Thanks for that!

The goal of compat-wireless was to support everything we can from
wireless-testing on older kernels. Because of this we need to backport
all supported work down to older kernels. Led and RFKILL particularly
were not as critical to backport as basic driver functionality.
Consider it a todo list item and those interested can work on it.

  Luis
