Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44870 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaBCGNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 01:13:48 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so5033096lbi.14
        for <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 22:13:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391404248.15536.78512217.1C6885ED@webmail.messagingengine.com>
References: <1391404248.15536.78512217.1C6885ED@webmail.messagingengine.com>
Date: Mon, 3 Feb 2014 08:13:46 +0200
Message-ID: <CANUX_P0fa+5+U_8W4r6mG128MEH+9mLZp0u6RKy65fbWrYCK=w@mail.gmail.com> (sfid-20140203_071414_428646_F874E6E4)
Subject: Re: Intel Wireless AC 7260 driver
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Alexander <alex@legion.mm.st>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 3, 2014 at 7:10 AM, Alexander <alex@legion.mm.st> wrote:
> Hello. I have some troubles with Intel Wireless AC 7260 notebook
> adapter. I have only N-speed (up to 300 mbps) with my AC router (ASUS
> RT-AC56U), but AC-speed is working in windows 8.1, iwconfig output has
> "IEEE 802.11abgn", Power Management is off. I tried Ubuntu 13.04 and
> 13.10 with 3.11 and 3.12 kernels. Can you help me?


As I already wrote on another mailing list: 11ac rates are not
supported on 3.12. The first kernel that supports 11ac rates is 3.13.
You can also install backport to update your wireless stack without
changing your underlying kernel:
