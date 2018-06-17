Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:34852 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932478AbeFQIhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 04:37:20 -0400
Received: by mail-io0-f196.google.com with SMTP id u4-v6so14300641iof.2
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jun 2018 01:37:20 -0700 (PDT)
MIME-Version: 1.0
From: Fabio Coatti <fabio.coatti@gmail.com>
Date: Sun, 17 Jun 2018 10:37:09 +0200
Message-ID: <CADpTngU_gzFp3y5Nmv3niwUgLSK5zAUwNUgM5NEPkiM552Cjww@mail.gmail.com> (sfid-20180617_103834_536273_3108D6B1)
Subject: 4.17.X iwlwifi: probe of 0000:04:00.0 failed with error -12
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying out 4.17 (.0 .1 .2) and I'm getting, on boot, this dmesg line:

iwlwifi: probe of 0000:04:00.0 failed with error -12

The wifi system is then unavailable.

On the very same hardware and configuration, kernel 4.16.3 works just fine.

Hardware: Lenovo P50
04:00.0 Network controller: Intel Corporation Wireless 8260 (rev 3a)

Linux firmware provided by gentoo, version 20180606

I'm willing to provide more info if needed, just let me know.
If you don't mind, please CC: me if answering as I'm not subscribed to
this list.

Many thanks in advance.
(I'm using gentoo with vanilla kernels, no distro patch applied)




-- 
Fabio
