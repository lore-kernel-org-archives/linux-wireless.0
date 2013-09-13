Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3IMLOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 07:14:05 -0400
Message-ID: <1379070837.14883.11.camel@jlt4.sipsolutions.net> (sfid-20130913_131409_392421_38A2A85C)
Subject: Re: [RFC 4/5] mac80211: add generic quiesce procedure
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Fri, 13 Sep 2013 13:13:57 +0200
In-Reply-To: <1379068568-27552-5-git-send-email-sgruszka@redhat.com> (sfid-20130913_123820_651597_6CC2956C)
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
	 <1379068568-27552-5-git-send-email-sgruszka@redhat.com>
	 (sfid-20130913_123820_651597_6CC2956C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-13 at 12:36 +0200, Stanislaw Gruszka wrote:
> Add function ieee80211_quiesce() end export it to allow be used by
> drivers. It is intended to be used before restart_hw to stop mac80211
> timers/works . Reverse quiesce on ieee80211_reconfig().

Why can't this be done inside restart_hw()?

johannes

