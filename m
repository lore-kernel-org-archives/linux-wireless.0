Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:59729 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbZIGVg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 17:36:56 -0400
Received: by iwn42 with SMTP id 42so1032669iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2009 14:36:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b55cabb00909070639s4a6f3c1cl8c3e2eccceaf81e8@mail.gmail.com>
References: <b55cabb00909070639s4a6f3c1cl8c3e2eccceaf81e8@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Date: Mon, 7 Sep 2009 14:36:39 -0700
Message-ID: <43e72e890909071436ub99bddbx3dd531d09f322b4a@mail.gmail.com>
Subject: Re: compat-wireless-old for ARM
To: AMAR SAHUKAR <amarsahu7@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 7, 2009 at 6:39 AM, AMAR SAHUKAR<amarsahu7@gmail.com> wrote:
> Hi,
>          I wanted to know the procedure to follow for installing
> compat-wireless-old on ARM platform. I am using a Netgear WG111V3 usb dongle
> which uses a rtl8187 chipset. I will be pleased if you can help me with
> this.

compat-wireless-old has not been updated for ages. Today is possible
to bring compat-wireless (instead of compat-wireless-old) down to
older kernels we previously could not since we no longer are using the
netdevice multiqueue support. I was able to bring compat-wireless down
to 2.6.25 -- at least compile-wise, there is also code present to help
bring it down to older kernels, we just need someone to test/help
finish the rest.

  Luis
