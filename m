Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1K3MQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 07:16:49 -0500
Subject: Re: [PATCH 2/4] nl80211: Parse channel type attribute in an ibss
 join request
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1322502917-28205-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1322502917-28205-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 13:16:46 +0100
Message-ID: <1322655406.3982.12.camel@jlt3.sipsolutions.net> (sfid-20111130_131652_560433_D64C26E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 18:55 +0100, Simon Wunderlich wrote:
> Prepare cfg80211 for IBSS HT:
>  * extend cfg80211 ibss struct with channel_type
>  * Check if extension channel can be used
>  * Export can_beacon_sec_chan for use in mac80211 (will be called
>    from ibss.c later).

I'm thinking there should be a "driver supports HT IBSS" flag, and we
reject the config otherwise?

johannes

