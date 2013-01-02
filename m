Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:45:51 -0500
Message-ID: <1357134362.9839.33.camel@jlt4.sipsolutions.net> (sfid-20130102_144553_607931_C18AE681)
Subject: Re: [PATCHv5 7/8] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:46:02 +0100
In-Reply-To: <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:

> +	drv_ap_channel_switch(local, ap_ch_switch);
> +	return 0;

Why is that not allowed to fail in the driver?

johannes

