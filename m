Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2F1IRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 04:17:17 -0400
Message-ID: <1340871433.4491.20.camel@jlt3.sipsolutions.net> (sfid-20120628_101721_950690_683D8844)
Subject: Re: [PATCH] mac80211: allow Rx in reconfig only after removing BA
 sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 10:17:13 +0200
In-Reply-To: <1340821557-27009-1-git-send-email-arik@wizery.com> (sfid-20120627_202603_132188_52D37BC7)
References: <1340821557-27009-1-git-send-email-arik@wizery.com>
	 (sfid-20120627_202603_132188_52D37BC7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 21:25 +0300, Arik Nemtsov wrote:
> Previously, a connected STA/AP could send us some AMPDUs right after
> recovery, without the driver knowing anything about it.

Huh, that description doesn't make a lot of sense? The STA/AP can send
us AMPDUs anyway without the driver knowing anything about it since it
has no idea we're restarting ...

johannes

