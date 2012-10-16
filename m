Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2JPTHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:07:19 -0400
Message-ID: <1350414472.10177.17.camel@jlt4.sipsolutions.net> (sfid-20121016_210723_620232_3C577B48)
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 16 Oct 2012 21:07:52 +0200
In-Reply-To: <1350226137-13704-7-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	 <1350226137-13704-7-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
> Add ieee80211_ap_process_chanswitch(), to handle a channel switch
> request for AP.
> 
> Add ieee80211_ap_ch_switch_done() which updates oper_channel
> and notifies upper layers about channel switch complete event.

Given channel contexts, how does this patch need to change?

johannes

