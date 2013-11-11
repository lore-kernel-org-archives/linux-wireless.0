Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KKPpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 10:45:49 -0500
Message-ID: <1384184745.14334.32.camel@jlt4.sipsolutions.net> (sfid-20131111_164556_239627_08A61034)
Subject: Re: [PATCH 1/2] mac80211: minstrels: spare numerous useless calls
 to get_random_bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 11 Nov 2013 16:45:45 +0100
In-Reply-To: <1383928473-798-1-git-send-email-karl.beldan@gmail.com> (sfid-20131108_173457_501914_FE444774)
References: <1383928473-798-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131108_173457_501914_FE444774)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-08 at 17:34 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> These are called to init the sample tables.
> This occurs once in minstrel_ht upon its registration (since it uses one
> single common sample table for all STAs), and once per sta addition in
> minstrel.

This commit log is suboptimal, it doesn't even seem to describe a change
but rather the behaviour after (or before?) the change?

johannes

