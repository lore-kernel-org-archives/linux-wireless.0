Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3HUNl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 09:41:29 -0400
Message-ID: <1377092481.15268.11.camel@jlt4.sipsolutions.net> (sfid-20130821_154133_569023_6CABF816)
Subject: Re: [PATCH-mac8011] mac80211: fix ignored channel parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 21 Aug 2013 15:41:21 +0200
In-Reply-To: <1377091825-30564-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1377091825-30564-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-21 at 15:30 +0200, Simon Wunderlich wrote:
> my earlier patch "mac80211: change IBSS channel state to chandef"
> created a regression by ignoring the channel parameter in
> __ieee80211_sta_join_ibss, which breaks IBSS channel selection. This
> patch fixes this situation by using the right channel and adopting the
> selected bandwidth mode.

Tested & applied.

johannes

