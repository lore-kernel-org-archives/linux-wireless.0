Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:44284 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbZKWJ60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 04:58:26 -0500
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 1/6] rt2x00: Only initialize HT on rt2800 devices that support it.
Date: Mon, 23 Nov 2009 10:58:31 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200911231058.31157.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 23. November 2009 08:16:00 schrieb Gertjan van Wingerde:
> Some RT28xx/RT30xx devices don't support 802.11n, when they are combined with
> the RF2020 chipset. Ensure that HT is disabled for these devices.

Hi Gertjan,

do you know if this fixes the RT2070L chipset? It's an RT3070 descendant without 802.11n support, I cracked the device open and there's no RF2020 to be seen - just a single RT2070L chip. Somebody posted that the RT2070L has the RF part integrated to make it cheaper, maybe RT2070 = RT3070 + RF2020 in a single chip?

I can't test my own device at the moment.

regards
Simon Raffeiner
