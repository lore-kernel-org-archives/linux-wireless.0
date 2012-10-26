Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab2JZUv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 16:51:29 -0400
Message-ID: <1351284718.10813.22.camel@jlt4.sipsolutions.net> (sfid-20121026_225133_300760_FA532F5A)
Subject: Re: [PATCH mac80211] mac80211: fix SSID copy on IBSS JOIN
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 26 Oct 2012 22:51:58 +0200
In-Reply-To: <1351270465-18946-1-git-send-email-ordex@autistici.org>
References: <1351270465-18946-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-26 at 18:54 +0200, Antonio Quartulli wrote:
> The 'ssid' field of the cfg80211_ibss_params is a u8 pointer and therefore the
> length is likely to be less than IEEE80211_MAX_SSID_LEN most of the times.
> 
> This patch fixes the ssid copy in ieee80211_ibss_join() by preventing it from
> reading beyond the string.
> 
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>

Applied, I also added Cc stable since this goes back a long time.

johannes

