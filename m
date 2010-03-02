Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23554 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab0CBIaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 03:30:18 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 00:30:18 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.53523.373634.82156@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 14:19:23 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
In-Reply-To: <43e72e891003020021l49191ceaye56c204e74a3c004@mail.gmail.com>
References: <19339.35506.86567.739868@gargle.gargle.HOWL>
	<43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
	<19340.37231.983326.296054@gargle.gargle.HOWL>
	<43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
	<19340.51272.987517.174933@gargle.gargle.HOWL>
	<43e72e891003012359jfb59df8t4c386a427b3c99a1@mail.gmail.com>
	<19340.52259.880731.243673@gargle.gargle.HOWL>
	<43e72e891003020021l49191ceaye56c204e74a3c004@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> You would be more familiar with the commonality between ath9k and
> ath9k_htc at this point. Even though the two drivers are separate
> right now, say we did remove the ath9k virtual wiphy, is there a set
> of mac80211 callbacks we can start sharing?

I don't think so, all of the callbacks involve issuing WMI commands
to the target, trying to workaround this would involve a lot of code churn.

Sujith
