Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3KYP5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 10:57:04 -0500
Message-ID: <1385395022.4443.27.camel@jlt4.sipsolutions.net> (sfid-20131125_165709_650248_146119C4)
Subject: Re: [PATCH] mac80211: set hw initial idle state
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 25 Nov 2013 16:57:02 +0100
In-Reply-To: <1384877525-23221-1-git-send-email-karl.beldan@gmail.com> (sfid-20131119_171259_657096_04847853)
References: <1384877525-23221-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131119_171259_657096_04847853)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-19 at 17:12 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM, the first call of ieee80211_do_open will configure the hw as
> non-idle, even if the interface being brought up is not a monitor, and
> this leads to inconsistent sequences like:

Applied.

johannes

