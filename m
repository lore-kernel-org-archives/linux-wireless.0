Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2LGHyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 02:54:20 -0500
Message-ID: <1354866882.9552.3.camel@jlt4.sipsolutions.net> (sfid-20121207_085422_856972_FB685815)
Subject: Re: [PATCH 02/24] regulatory: don't allocate too much memory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Dec 2012 08:54:42 +0100
In-Reply-To: <CAB=NE6XWKoRODSOcmgxhENmC3ZkOO5qCE-RBHwaMA-vusz+Dqw@mail.gmail.com> (sfid-20121207_004802_079404_D7922887)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-3-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6XWKoRODSOcmgxhENmC3ZkOO5qCE-RBHwaMA-vusz+Dqw@mail.gmail.com>
	 (sfid-20121207_004802_079404_D7922887)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 15:47 -0800, Luis R. Rodriguez wrote:

> Just for the record without this I ran into odd issues that I could
> not root cause but glad you have verified this should be a non-issue.
> I'll ACK-it provided we let it rip and find any issues during in the
> development cycle.

I'm pretty that was the same issue I just fixed in patch 1 :-)

johannes

