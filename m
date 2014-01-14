Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaANQVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:21:47 -0500
Message-ID: <1389716504.32635.16.camel@jlt4.sipsolutions.net> (sfid-20140114_172150_291180_A6EFEA25)
Subject: Re: [RFC 1/4] nl80211: make chandef parser take nlattr arg
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 17:21:44 +0100
In-Reply-To: <1389715458.32635.3.camel@jlt4.sipsolutions.net> (sfid-20140114_170426_833501_F338BE16)
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	 <1389194818-7864-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140108_163115_371270_4B089B95) <1389715458.32635.3.camel@jlt4.sipsolutions.net>
	 (sfid-20140114_170426_833501_F338BE16)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 17:04 +0100, Johannes Berg wrote:
> On Wed, 2014-01-08 at 16:26 +0100, Michal Kazior wrote:
> > The chandef parsing function doesn't need to
> > access genl_info. It just needs the attrs field.
> 
> This seems reasonable regardless of everything else, I'll apply it.

Actually I changed my mind again - if we need to change other things
that'd be just churn. I have no objection to this though, so if it turns
out to be useful or needed we can do it.

johannes

