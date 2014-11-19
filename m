Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40063 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770AbaKSRyH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:54:07 -0500
Message-ID: <1416419644.9374.11.camel@sipsolutions.net> (sfid-20141119_185411_495731_D33AC1BB)
Subject: Re: [PATCH v2] mac80211-hwsim: hwname is always known so use the
 value from wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 18:54:04 +0100
In-Reply-To: <1415963794-28664-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141114_121658_943954_812D6F1D)
References: <1415963794-28664-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141114_121658_943954_812D6F1D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-14 at 13:16 +0200, Jukka Rissanen wrote:
> We can always know the hwname of the radio so use the value
> from wiphy.

Applied. I was hoping you'd fix the smatch thing but I guess not ... did
that myself now.

johannes

