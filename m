Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55266 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab0LTIK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 03:10:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 00:10:12 -0800
Date: Mon, 20 Dec 2010 13:40:03 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k: Fix warnings on card removal
Message-ID: <20101220081003.GA19301@vmraj-lnx.users.atheros.com>
References: <1292660258-4063-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1292660258-4063-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 18, 2010 at 01:47:37PM +0530, Rajkumar Manoharan wrote:
> There is no point in doing register read/write operations
> when is hardware is not present. This leads to unnecessary
> warnings on log. This patch resolves the following
> warnings on card removal.
> 
John,

This patch does not handle module unload case. will send v2 patch.

--
Rajkumar
