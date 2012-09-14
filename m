Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2INMZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:25:06 -0400
Message-ID: <1347625542.4060.2.camel@jlt4.sipsolutions.net> (sfid-20120914_142511_833177_B3119A8E)
Subject: Re: [PATCH] mac80211: allow re-open the blocked peer link in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 14 Sep 2012 14:25:42 +0200
In-Reply-To: <1347603511-31165-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120914_082232_846107_2ADDD726)
References: <1347603511-31165-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120914_082232_846107_2ADDD726)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-14 at 14:18 +0800, Chun-Yeow Yeoh wrote:
> Peer link which is blocked using the "iw mesh0 station
> set <MAC addr> plink_action block" is previously not able
> to re-open using "iw mesh0 station set <MAC addr>
> plink_action open". This patch is intended to solve this.

Applied.

> If the station plink state remains at OPN_SNT once open,
> try block and open again should solve this problem.

Not really sure I understand this part, but whatever :)

johannes

