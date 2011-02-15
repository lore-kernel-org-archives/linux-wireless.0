Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1BOQFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 11:05:40 -0500
Subject: Re: [RFC/RFT] mac80211: make tx() operation return void
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <19802.41912.909410.520385@gargle.gargle.HOWL>
References: <1297778837.8664.0.camel@jlt3.sipsolutions.net>
	 <19802.41912.909410.520385@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 17:05:39 +0100
Message-ID: <1297785939.8664.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 21:33 +0530, Sujith wrote:

> No problems with this change for ath9k_htc, but if required I can
> send this as a separate patch...

Go ahead and send it -- I still need to test this etc. and it won't go
into the current / stable either.

johannes

