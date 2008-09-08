Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39446 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYIHFZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 01:25:53 -0400
Date: Mon, 8 Sep 2008 10:50:28 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080908052028.GB28149@vasanth-lnx.users.atheros.com> (sfid-20080908_072556_901224_6F7E89C0)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com> <20080907120901.GB15895@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080907120901.GB15895@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> IMO, if a driver has added rfkill support, and it is enabled, that driver
> must refuse to load if it cannot register with the rfkill subsystem (that
> only happens due to bugs or OOM conditions, anyway).
> 
> Once you support rfkill in a piece of hardware and that support starts being
> used, the configurations using your driver might start to depend on rfkill
> being operational to be safe to operate in may user cases.
> 
> So, please consider shutting down the radio and aborting the driver load if
> you cannot properly register rfkill support in ath9k.
ok, thanks.

-vasanth
