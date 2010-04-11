Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36823 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab0DKFwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 01:52:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 22:52:40 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19393.25461.196138.115937@gargle.gargle.HOWL>
Date: Sun, 11 Apr 2010 11:21:49 +0530
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] ath9k-htc: fix lockdep warning and kernel warning after unplugging ar9271 usb device
In-Reply-To: <1270915827-4525-1-git-send-email-tom.leiming@gmail.com>
References: <1270915827-4525-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tom.leiming@gmail.com wrote:
> This patch fixes two warnings below after unplugging ar9271 usb device:
>         -one is a kernel warning[1]
>         -another is a lockdep warning[2]
> 

[snip]

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Acked-by: Sujith <Sujith.Manoharan@atheros.com>

Sujith
