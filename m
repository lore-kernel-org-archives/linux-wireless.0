Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33634 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756750AbZLNLBv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 06:01:51 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 03:01:51 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
Message-ID: <19238.7116.226902.466841@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 16:34:44 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Kalle Valo <kalle.valo@iki.fi>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/6] ath9k: Stop ANI when doing a reset
In-Reply-To: <87pr6hzwpf.fsf@purkki.valot.fi>
References: <19238.1557.201259.642604@gargle.gargle.HOWL>
	<87pr6hzwpf.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> The visible change to the user is good to explain. Was there packet
> loss, did the kernel crash or what?

Sub-optimal performance would be the visible impact.

Updated patch will follow momentarily.
Thanks for the review.

Sujith
