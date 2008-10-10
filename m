Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56374
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761285AbYJJT05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:26:57 -0400
Date: Fri, 10 Oct 2008 12:26:33 -0700 (PDT)
Message-Id: <20081010.122633.261467939.davem@davemloft.net> (sfid-20081010_212702_690036_E773F3BB)
To: lrodriguez@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Fix return code when ath9k_hw_setpower()
 fails on reset
From: David Miller <davem@davemloft.net>
In-Reply-To: <1223641374-11872-2-git-send-email-lrodriguez@atheros.com>
References: <1223641374-11872-1-git-send-email-lrodriguez@atheros.com>
	<1223641374-11872-2-git-send-email-lrodriguez@atheros.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 10 Oct 2008 05:22:54 -0700

> We were not reporting a status code back ath9k_hw_setpower() failed
> during reset so lets correct this.
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Also applied, thanks Luis.
