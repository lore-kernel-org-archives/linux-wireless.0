Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51452 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934043Ab3BMOEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:04:12 -0500
Message-ID: <1360764243.8868.11.camel@jlt4.sipsolutions.net> (sfid-20130213_150418_217563_9BB7E369)
Subject: Re: [PATCHv10 2/2] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 13 Feb 2013 15:04:03 +0100
In-Reply-To: <1360343782-32149-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1360343782-32149-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1360343782-32149-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 18:16 +0100, Simon Wunderlich wrote:
> Add command to trigger radar detection in the driver/FW.
> Once radar detection is started it should continuously
> monitor for radars as long as the channel active.
> If radar is detected usermode notified with 'radar
> detected' event.

Applied both -- I changed a few minor things (and corrected the function
name mistake).

I may need reminding to apply the iw patches when this has gone to
John's tree.

johannes

