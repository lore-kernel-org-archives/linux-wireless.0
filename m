Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49115 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0FFF5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 01:57:01 -0400
Received: by vws5 with SMTP id 5so1784503vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jun 2010 22:57:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C0B32E8.4080208@gmail.com>
References: <4C0B32E8.4080208@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 5 Jun 2010 22:56:39 -0700
Message-ID: <AANLkTikgARRZOd1kMUbT3fQLbgHLU0-6Y0kbDw7EmMYX@mail.gmail.com>
Subject: Re: [Patch] Enable rt2800usb in compat-wireless stable branch
To: Richard Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 5, 2010 at 10:32 PM, Richard Farina <sidhayn@gmail.com> wrote:
> This patch enables the new RT307x and RT357x chips in compat-wireless
> stable.  I'd like to enable the same for rt2800pci as well but right now it
> doesn't seem to build so I'll wait till it does to submit the diff.
>
> Thanks,
> Rick Farina
>
> Don't see why this is needed to patch config.mk but:
> Signed-off-by: Rick Farina
>

Manged the patch commit log a bit, but applied it thanks. Will
propagate to 2.6.35.y on the next release.

Thanks!

  Luis
