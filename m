Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46981 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933550AbZGPXQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:16:07 -0400
Received: by gxk9 with SMTP id 9so836562gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 16:16:06 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 16:15:46 -0700
Message-ID: <43e72e890907161615h507e9c59r421d23d22ff05459@mail.gmail.com>
Subject: Re: [KARMIC] review these for rt2x00 (adds rt2800pci)
To: Stefan Bader <stefan.bader@canonical.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Cc: Manoj Iyer <manoj.iyer@canonical.com>,
	kernel-team@lists.ubuntu.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 9:56 AM, Stefan Bader<stefan.bader@canonical.com> wrote:
> At least this seems to be material for 3 or 4 patches
> - adapt the rfkill stuff
> - some documentation update
> - add the new pci version of the 2800 (with that rt2x00soc lib
>   which might be another patch)
> - and some fixes...

Not only that but this driver is not yet merged upstream, there should
be a good reason for that.

Ivo, what's the status on rt2800pci? Some users have been asking about it.

  Luis
