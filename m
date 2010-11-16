Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tulikuusama.dnainternet.net ([83.102.40.132]:57904 "EHLO
	tulikuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab0KPXuC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 18:50:02 -0500
Message-ID: <20101117014957.19165rsfffapfudc@hayate.sektori.org>
Date: Wed, 17 Nov 2010 01:49:57 +0200
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rndis_wlan: avoid uninitialized var warning in
	rndis_wlan_craft_connected_bss
References: <1289944148-10326-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1289944148-10326-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

>   CC [M]  drivers/net/wireless/rndis_wlan.o
> drivers/net/wireless/rndis_wlan.c: In function  
> ‘rndis_wlan_craft_connected_bss’:
> drivers/net/wireless/rndis_wlan.c:2542:2: warning: ‘ret’ may be used  
> uninitialized in this function
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Ah.. yes, netdev_dbg needs the return value. Thanks.

Acked-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

