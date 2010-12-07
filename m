Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0LGSaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 13:30:06 -0500
Subject: Re: [PATCH v4] cfg80211/mac80211: add mesh join/leave commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1291746157-14628-1-git-send-email-javier@cozybit.com>
References: <1291746157-14628-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 19:29:52 +0100
Message-ID: <1291746592.3607.53.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 10:22 -0800, Javier Cardona wrote:

> v4: - wrap mesh sections inside CONFIG_MAC80211_MESH to 
>       fix compilation problems reported by Stephen Rothwell,
>       Larry Finger and Bruno Randolf.

Thanks, but since it was already applied we probably need a follow-on
fixup patch?

johannes

