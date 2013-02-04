Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3BDQBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 11:01:46 -0500
Message-ID: <1359993726.17993.3.camel@jlt4.sipsolutions.net> (sfid-20130204_170149_451677_9CD8FEB7)
Subject: Re: [PATCHv5] mac80211: mesh power save basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Mon, 04 Feb 2013 17:02:06 +0100
In-Reply-To: <1359566048-16378-1-git-send-email-marco@cozybit.com> (sfid-20130130_181422_015732_445666FB)
References: <1359566048-16378-1-git-send-email-marco@cozybit.com>
	 (sfid-20130130_181422_015732_445666FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 18:14 +0100, Marco Porsch wrote:
> Add routines to
> - maintain a PS mode for each peer and a non-peer PS mode
> - indicate own PS mode in transmitted frames
> - track neighbor STAs power modes
> - buffer frames when neighbors are in PS mode
> - add TIM and Awake Window IE to beacons
> - release frames in Mesh Peer Service Periods
[...]

Applied. I didn't very carefully review the changes from v4 though.

johannes

