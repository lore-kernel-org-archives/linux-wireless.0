Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1AWKFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 05:05:05 -0500
Subject: Re: [RFC/WIP 00/33] ath9k_htc AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <19771.64642.436528.605150@gargle.gargle.HOWL>
References: <19768.62903.947245.576431@gargle.gargle.HOWL>
	 <201101212226.40435.chunkeey@googlemail.com>
	 <19770.18241.787715.680555@gargle.gargle.HOWL>
	 <19770.18332.859418.283909@gargle.gargle.HOWL>
	 <19770.20402.711305.279934@gargle.gargle.HOWL>
	 <1295773884.3639.9.camel@jlt3.sipsolutions.net>
	 <19771.64642.436528.605150@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 11:05:03 +0100
Message-ID: <1295777103.3639.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 15:31 +0530, Sujith wrote:

> * The host driver has no way of knowing if the FW failed to send out a frame,
>   so keeping track of pending frames is impossible. Am not sure if ATH9K_TXERR_FILT
>   is similar to TX_STATUS_FAIL_DEST_PS in iwlagn (I think not), so that can't be used
>   either.

I don't know, but I thought it was supposed to be? At least mac80211
calls this "filtered" as well, which surely comes from Atheros
terminology.

johannes

