Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36912 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab1EYMpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 08:45:23 -0400
Received: by fxm17 with SMTP id 17so5334967fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 May 2011 05:45:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Marius Ladegaard Meyer <marius.l.meyer@gmail.com>
Subject: Re: carl9170 fw 1.9.3 on the binary archive page
Date: Wed, 25 May 2011 14:45:10 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTinenbgnE0c8ZQh2wfBOjWNc=T++Dw@mail.gmail.com> <201105241811.05128.chunkeey@googlemail.com> <BANLkTik7Gg81+KaB2eGnkpG8kSzTD7cwaw@mail.gmail.com>
In-Reply-To: <BANLkTik7Gg81+KaB2eGnkpG8kSzTD7cwaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201105251445.11193.chunkeey@googlemail.com> (sfid-20110525_144527_675307_00702157)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 May 2011 20:49:17 Marius Ladegaard Meyer wrote:
> I'm sorry if I was not quite clear. I am not an "official" maintainer for
> Arch Linux in any way, I simply wrote a package script for other users to
> download from the Arch User Reposiroty. With the binaries on the mirror I
> linked to, this is almost a one-liner, whereas a personal build for every
> user is a little bit more complicated (since I'm not a dev I cannot push a
> binary package to the official repos, and the AUR forbids binaries).
It would be a easier if the firmware didn't need its own toolchain and
could use the one provided by the distro.

> But I figure now that I might want to ask the dev's at Arch to make a package
> of this instead. I tried once or twice to build the fw from git (and filed you
> a bug about a missing dir if you remember) but I did not end up with a
> useable carl9170-1.fw.
now you see, this is interesting. You tried once or twice to build the fw, but
the resulting firmware image was not usable in the end? Can you explain in
detail why it/they was/were "not usable"?

Did the driver reject the image?
Did it you get a "-110" (timeout) during init?
interface created? scan works? can connect?
...

or is it more like:
"actually stuff works pretty much like before, but because this is not
official and it doesn't work "better" it must be broken."

Regards,
	Chr
