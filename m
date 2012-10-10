Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2JJJBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 05:01:36 -0400
Message-ID: <1349859730.4683.41.camel@jlt4.sipsolutions.net> (sfid-20121010_110139_761199_051B4478)
Subject: Re: [PATCH 1/2] mac80211: move out the non-statistics variable
 estab_plinks from mesh_stat
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Wed, 10 Oct 2012 11:02:10 +0200
In-Reply-To: <1349814468-6512-1-git-send-email-ashok@cozybit.com> (sfid-20121009_222801_772859_E37AD288)
References: <1349814468-6512-1-git-send-email-ashok@cozybit.com>
	 (sfid-20121009_222801_772859_E37AD288)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-09 at 13:27 -0700, Ashok Nagarajan wrote:
> estab_plinks is not a statistics member. Hence move estab_plinks from
> struct mesh_stat to struct ieee80211_if_mesh

Applied.

johannes

