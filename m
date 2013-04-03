Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077Ab3DCMqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:46:45 -0400
Message-ID: <1364993200.8351.35.camel@jlt4.sipsolutions.net> (sfid-20130403_144710_438704_8F70ED9E)
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 03 Apr 2013 14:46:40 +0200
In-Reply-To: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130402_184017_183870_B78BD6C4)
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130402_184017_183870_B78BD6C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-04-02 at 18:39 +0200, Simon Wunderlich wrote:
> local->hw.conf maybe not be synced when recalcing whether radar is
> enabled, sometimes leaving radar enabled even if it's not neccesary
> anymore.

I don't really see how, can you explain more?

johannes

