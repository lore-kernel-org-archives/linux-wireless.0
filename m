Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3EXVTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 17:19:35 -0400
Message-ID: <1369430370.13623.9.camel@johannes> (sfid-20130524_231940_096158_4F506520)
Subject: Re: [PATCH] mac80211: Move mesh estab_plinks outside mesh_stats
 debug group
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, javier@cozybit.com
Date: Fri, 24 May 2013 23:19:30 +0200
In-Reply-To: <1368490084-10711-1-git-send-email-ashok@cozybit.com> (sfid-20130514_020816_418057_C105AD4F)
References: <1368490084-10711-1-git-send-email-ashok@cozybit.com>
	 (sfid-20130514_020816_418057_C105AD4F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-13 at 17:08 -0700, Ashok Nagarajan wrote:
> As estab_plinks is not a statistics member, don't show its debug information
> along with other mesh stat members

Applied.

johannes

