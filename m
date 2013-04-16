Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114Ab3DPOAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 10:00:02 -0400
Message-ID: <1366120796.8244.15.camel@jlt4.sipsolutions.net> (sfid-20130416_160009_412255_0277E575)
Subject: Re: [PATCH] mac80211: fix rate control tx handler for VHT rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 16 Apr 2013 15:59:56 +0200
In-Reply-To: <1366043301-6681-1-git-send-email-karl.beldan@gmail.com> (sfid-20130415_183241_214775_3D7AD65D)
References: <1366043301-6681-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130415_183241_214775_3D7AD65D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 18:28 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Handle VHT rates like HT ones, otherwise we easily trigger the pre-HT
> rates WARN_ON(rc_rate->idx >= sband->n_bitrates) which will set
> rc_rate->idx to -1.

Applied, thanks.

johannes

