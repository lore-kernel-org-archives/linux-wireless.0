Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3FRMON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:14:13 -0400
Message-ID: <1371557649.8318.9.camel@jlt4.sipsolutions.net> (sfid-20130618_141426_985398_70AB8C77)
Subject: Re: [RFC 1/2] mac80211:  Stop timer before deleting data structures.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Jun 2013 14:14:09 +0200
In-Reply-To: <1371515281-26879-1-git-send-email-greearb@candelatech.com> (sfid-20130618_022817_510140_40562029)
References: <1371515281-26879-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130618_022817_510140_40562029)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-17 at 17:28 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Not sure this matters, but it seems cleaner.

It really doesn't make a difference at all since it's all locked and the
timer just fires off the work struct.

johannes

