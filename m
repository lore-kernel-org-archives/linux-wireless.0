Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:58584 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab3DEKLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 06:11:51 -0400
Message-ID: <515EA364.3020407@neratec.com> (sfid-20130405_121154_633754_55BEC115)
Date: Fri, 05 Apr 2013 12:11:48 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1364993200.8351.35.camel@jlt4.sipsolutions.net> <515D8259.1030208@neratec.com> <20130404182219.GA24704@pandem0nium> <515EA285.5010004@neratec.com>
In-Reply-To: <515EA285.5010004@neratec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 12:08 PM, Zefir Kurtisi wrote:
> 1) enable DFS log output at ath9k
> echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug
> 
C&P garbage, the right command is of course:

echo 0x20400 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug

