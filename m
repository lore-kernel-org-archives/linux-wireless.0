Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2078 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZGUTab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 15:30:31 -0400
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
In-Reply-To: <20090721191154.22374.17349.stgit@tikku>
References: <20090721191136.22374.69017.stgit@tikku>
	 <20090721191154.22374.17349.stgit@tikku>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 12:29:00 -0700
Message-Id: <1248204540.31365.275.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-21 at 22:11 +0300, Kalle Valo wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
> Add myself as the maintainer for wl1251 driver.
> +WL1251 WIRELESS DRIVER
> +P:	Kalle Valo
> +M:	kalle.valo@nokia.com
> +L:	linux-wireless@vger.kernel.org
> +W:	http://wireless.kernel.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> +S:	Maintained
> +F:	drivers/net/wireless/wl12xx/wl1251*

Not that I'm asking you to maintain more than you want to,
but why not:

F:	drivers/net/wireless/wl12xx/

? cheers, Joe

