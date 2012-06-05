Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab2FEMLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 08:11:13 -0400
Message-ID: <1338898271.4514.38.camel@jlt3.sipsolutions.net> (sfid-20120605_141117_020655_871CB4D5)
Subject: [ANN] new wireless stack trees
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Date: Tue, 05 Jun 2012 14:11:11 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Given the amount of work going on in the various wireless stack
components, I've decided that I'll reflect my maintainer role also in
git trees. I've created new trees and will pick patches for
 * mac80211
 * cfg80211
 * rfkill (if needed)

into the new trees
 * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=summary
 * http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=summary

Yes, I've called them "mac80211", but I will also pick up the other
components into them. Calling them "wireless" would have been too
confusing.

These trees feed John's wireless and wireless-next trees respectively.

I won't maintain an integration tree like John's wireless-testing,
please continue to use his. If merge conflicts make it necessary, I'll
resolve them in separate branches etc. and work it out with John.

I will probably ask for these trees to be included in linux-next, but I
need a bit of ramp-up time before that I think :-)


As a result, I ask you to not submit patch series that touch both your
driver and the stack, please submit them independently. John will have
to wait applying the patches to the driver until has has pulled in any
dependencies via my trees.

If you maintain your own driver trees you're free to merge these trees
if you need their contents, but please don't send my contents to John
yourself, wait with your merge requests and nag me if you need me to
push to John :-)

A word of caution though: I've not done this before, so while I think I
know what I'm signing up for I'm sure I'll make mistakes. If you pull my
tree in and I have to rebase due to those mistakes then would have to
rebase as well, so maybe don't pull it tomorrow but give me some time to
adjust to the workflow.


Of course I'll continue to post my own patches to the mailing list well
before I applying them.

johannes

