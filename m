Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1BCIQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 03:16:48 -0500
Subject: Re: Crash in timer.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D49DABE.7040802@candelatech.com>
References: <4D49DABE.7040802@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 09:16:44 +0100
Message-ID: <1296721004.3854.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 14:29 -0800, Ben Greear wrote:
> I had 128 STA vifs on an ath9k system...started deleting all but 16 of them.
> I did this twice, and both times, it crashes before finishing deleting
> all of them.
> 
> This is using latest wireless-testing plus some of my patches
> previously posted to this list.

Timers should have debug objects support -- that would be helpful.

johannes

