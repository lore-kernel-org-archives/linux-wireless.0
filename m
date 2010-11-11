Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63460 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0KKSgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 13:36:24 -0500
Received: by iwn10 with SMTP id 10so2470945iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 10:36:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6105834.1111289487490143.JavaMail.wlan@CHBU500181>
References: <17186438.751289486686690.JavaMail.wlan@CHBU500181> <6105834.1111289487490143.JavaMail.wlan@CHBU500181>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 10:36:02 -0800
Message-ID: <AANLkTikJzj8RdpEddxmjm1FP8g79J0twvouKvut7AWb8@mail.gmail.com>
Subject: Re: [PATCH 6/9] ath5k: AHB port. Use more generic functions for
 finding mac revision instead of pci specific.
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 6:58 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
> Use ath5k_bus_read_srev as a wrapper for MAC revision register reading. Different buses have
> to aceess it with own functions before hardware is initialized.
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>

Your subject is too long, trim it, remove all that AHB port on every
single patch.
Also, have you run all your patches through ./scripts/checkpatch.pl
prior to submission?

 Luis
