Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3DIJuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 05:50:23 -0400
Message-ID: <1365501017.8465.12.camel@jlt4.sipsolutions.net> (sfid-20130409_115027_926768_5A6C42DA)
Subject: Re: [PATCHv4] mac80211: fix recalc_radar hwconf sync problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de, ordex@autistici.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 09 Apr 2013 11:50:17 +0200
In-Reply-To: <1365453796-17572-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130408_224347_713775_388BD8E8)
References: <20130408175352.GC5938@ritirata.org>
	 <1365453796-17572-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130408_224347_713775_388BD8E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 22:43 +0200, Simon Wunderlich wrote:
> local->hw.conf maybe not be synced when recalcing whether radar is
> enabled, sometimes leaving radar enabled even if it's not neccesary
> anymore.
> 
> Fix this by:
>  * setting radar_enabled when creating the chanctx
>  * turning radar_enabled off before destroying the last channel context

Applied.

johannes

