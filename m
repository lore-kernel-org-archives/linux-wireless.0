Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34763 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0KJUO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 15:14:56 -0500
Date: Wed, 10 Nov 2010 15:06:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] carl9170: use generic sign_extend32
Message-ID: <20101110200635.GF2714@tuxdriver.com>
References: <cover.1288393804.git.chunkeey@googlemail.com>
 <9f86a3d821426da8b6e3d9b7b8ab7bd9f8e76d71.1288393804.git.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <9f86a3d821426da8b6e3d9b7b8ab7bd9f8e76d71.1288393804.git.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 29, 2010 at 11:11:23PM +0200, Christian Lamparter wrote:
> This patch replaces the handcrafted
> sign extension cruft with a generic
> bitop function.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>

  CC [M]  drivers/net/wireless/ath/carl9170/phy.o
drivers/net/wireless/ath/carl9170/phy.c: In function ‘carl9170_get_noisefloor’:
drivers/net/wireless/ath/carl9170/phy.c:1572: error: implicit declaration of function ‘sign_extend32’
make[3]: *** [drivers/net/wireless/ath/carl9170/phy.o] Error 1
make[2]: *** [drivers/net/wireless/ath/carl9170] Error 2
make[1]: *** [drivers/net/wireless/ath] Error 2
make: *** [drivers/net/wireless/] Error 2

Maybe we should wait until this function exists before we use it? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
