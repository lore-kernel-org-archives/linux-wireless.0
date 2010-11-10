Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45127 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab0KJUWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 15:22:00 -0500
Received: by fxm16 with SMTP id 16so735997fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 12:21:59 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/6] carl9170: use generic sign_extend32
Date: Wed, 10 Nov 2010 21:21:49 +0100
Cc: linux-wireless@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <cover.1288393804.git.chunkeey@googlemail.com> <9f86a3d821426da8b6e3d9b7b8ab7bd9f8e76d71.1288393804.git.chunkeey@googlemail.com> <20101110200635.GF2714@tuxdriver.com>
In-Reply-To: <20101110200635.GF2714@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011102121.50082.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 November 2010 21:06:36 John W. Linville wrote:
> On Fri, Oct 29, 2010 at 11:11:23PM +0200, Christian Lamparter wrote:
> > This patch replaces the handcrafted
> > sign extension cruft with a generic
> > bitop function.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> 
>   CC [M]  drivers/net/wireless/ath/carl9170/phy.o
> drivers/net/wireless/ath/carl9170/phy.c: In function ‘carl9170_get_noisefloor’:
> drivers/net/wireless/ath/carl9170/phy.c:1572: error: implicit declaration of function ‘sign_extend32’
> make[3]: *** [drivers/net/wireless/ath/carl9170/phy.o] Error 1
> make[2]: *** [drivers/net/wireless/ath/carl9170] Error 2
> make[1]: *** [drivers/net/wireless/ath] Error 2
> make: *** [drivers/net/wireless/] Error 2
> 
> Maybe we should wait until this function exists before we use it? :-)
interesting,

https://patchwork.kernel.org/patch/143241/

so why exactly wasn't this patch merged?

Regards,
	Chr
