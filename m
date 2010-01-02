Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48891 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0ABRoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 12:44:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH] b43: N-PHY: clean table init, check PHY rev (V2)
Date: Sat, 2 Jan 2010 18:43:55 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
References: <op.u5wyyryj9lhzdc@linux-g0th.site>
In-Reply-To: <op.u5wyyryj9lhzdc@linux-g0th.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001021843.57583.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 January 2010 17:33:53 Rafał Miłecki wrote:
> --- a/drivers/net/wireless/b43/tables_nphy.h
> +++ b/drivers/net/wireless/b43/tables_nphy.h

> -extern const u8 b43_ntab_adjustpower0[];
> +static const u8 b43_ntab_adjustpower0[];

Are you serious? o.O
Come on... You can do better ;)

-- 
Greetings, Michael.
