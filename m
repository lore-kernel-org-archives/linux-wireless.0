Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3JAKQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 06:16:47 -0400
Message-ID: <1380622603.14430.3.camel@jlt4.sipsolutions.net> (sfid-20131001_121654_038571_6E028E67)
Subject: Re: [PATCH 1/3] mac80211: fix some snprintf misuses
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Date: Tue, 01 Oct 2013 12:16:43 +0200
In-Reply-To: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net> (sfid-20130830_104931_636456_970396D8)
References: <1377852561-16754-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130830_104931_636456_970396D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-30 at 10:49 +0200, Johannes Berg wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> In some debugfs related functions snprintf was used
> while scnprintf should have been used instead.
> 
> (blindly adding the return value of snprintf and supplying
> it to the next snprintf might result in buffer overflow when
> the input is too big)

Applied.

johannes

