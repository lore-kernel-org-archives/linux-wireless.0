Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAFNcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 08:32:41 -0500
Message-ID: <1389015147.5891.11.camel@jlt4.sipsolutions.net> (sfid-20140106_143246_868277_74E5D131)
Subject: Re: [PATCH 0/3] cfg80211: process pending regulatory requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>
Date: Mon, 06 Jan 2014 14:32:27 +0100
In-Reply-To: <1264577938.20140106141031@eikelenboom.it>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
	 <1264577938.20140106141031@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 14:10 +0100, Sander Eikelenboom wrote:
> Hi All,
> 
> "Give me a ping, Vasili. One ping only, please."
> 
> Or in other words .. what is the status of this patchset by Luis ?

Well, I went on vacation the day Luis posted it, and now I'm back ...
I'll need to review it, etc. If anyone wants to port it to 3.13, be my
guest, but since this is not an immediate regression I doubt it makes
sense to try to bubble it into 3.13 from my tree at this point just
before the release.

johannes

