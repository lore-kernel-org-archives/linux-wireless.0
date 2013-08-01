Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3HAHhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 03:37:02 -0400
Message-ID: <1375342617.8608.5.camel@jlt4.sipsolutions.net> (sfid-20130801_093722_185131_3C1B6C20)
Subject: Re: [RFC 0/3] introduce chan_time parameter to scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Thu, 01 Aug 2013 09:36:57 +0200
In-Reply-To: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-29 at 10:39 +0200, Michal Kazior wrote:

> I'm wondering if it would be okay to set swscan
> probe delay to 0 if chan_time is non-zero? Or does
> probe delay need to be non-zero? Or maybe it
> should also be configurable via a parameter?

probe delay needs to be non-zero for NAV adjustment.

johannes

