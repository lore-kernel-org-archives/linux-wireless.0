Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaBYP2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 10:28:12 -0500
Message-ID: <1393342083.4170.16.camel@jlt4.sipsolutions.net> (sfid-20140225_162816_929920_EB641B3C)
Subject: Re: [PATCH 2/2] cfg80211: regulatory, allow user to set world
 regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Tue, 25 Feb 2014 16:28:03 +0100
In-Reply-To: <1392364441-4640-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140214_085422_293607_23F25481)
References: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1392364441-4640-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140214_085422_293607_23F25481)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-14 at 08:54 +0100, Janusz Dziedzic wrote:
> Allow to set world regulatory domain in case of user
> request (iw reg set 00).

Applied both, I took the first one for 3.14 still.

johannes

