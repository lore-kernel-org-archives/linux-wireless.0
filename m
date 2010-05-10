Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0EJHig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 03:38:36 -0400
Subject: Re: [patch 3/9] ath9k: cleanup: u32 => bool
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
In-Reply-To: <20100508162247.GO27064@bicker>
References: <20100508162247.GO27064@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 09:38:26 +0200
Message-ID: <1273477106.3573.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-08 at 18:22 +0200, Dan Carpenter wrote:

> +		bool on = param ? 1 : 0;

umm, if you're going to use bool then use true/false too.

johannes

