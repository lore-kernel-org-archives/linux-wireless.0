Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56966 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0A1SCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 13:02:00 -0500
Received: by pwi21 with SMTP id 21so658532pwi.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2010 10:02:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201001282327.04853.kel@otaku42.de>
References: <4B5CB7AB.7010105@bzz.no> <87bpghnp4v.fsf@purkki.valot.fi>
	<43e72e891001261106w493225c2g6e9a5ff0ef9e41de@mail.gmail.com>
	<201001282327.04853.kel@otaku42.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 28 Jan 2010 10:01:40 -0800
Message-ID: <43e72e891001281001g5fae7bceoae57a426df13b8e0@mail.gmail.com>
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
To: Kel Modderman <kel@otaku42.de>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John S. Skogtvedt" <jss@bzz.no>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2010 at 5:27 AM, Kel Modderman <kel@otaku42.de> wrote:

> Am happy for anyone else to pick up my stuff, take it change it and get a
> painless, just working, set of the software in Debian. Or even just the latter
> bit :)
>
>> Also can you recommend a kernel contact, I'd
>> like to recommend to not use CONFIG_WIRELESS_OLD_REGULATORY for a few
>> reasons [1] as it seems to be the default on the current 2.6.32
>> kernel.
>
> Debian Kernel Team <debian-kernel@lists.debian.org>, more details at:
> http://packages.qa.debian.org/l/linux-latest-2.6.html

Thanks for all your work and details, I'll go poke
debian-kernel@lists.debian.org now to see if I can help. I can try to
help with the packaging and see if there are any questions regarding
that stuff or CONFIG_WIRELESS_OLD_REGULATORY.

  Luis
