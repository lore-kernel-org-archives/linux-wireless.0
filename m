Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaANQEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 11:04:23 -0500
Message-ID: <1389715458.32635.3.camel@jlt4.sipsolutions.net> (sfid-20140114_170426_833501_F338BE16)
Subject: Re: [RFC 1/4] nl80211: make chandef parser take nlattr arg
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Jan 2014 17:04:18 +0100
In-Reply-To: <1389194818-7864-2-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163115_371270_4B089B95)
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
	 <1389194818-7864-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140108_163115_371270_4B089B95)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-08 at 16:26 +0100, Michal Kazior wrote:
> The chandef parsing function doesn't need to
> access genl_info. It just needs the attrs field.

This seems reasonable regardless of everything else, I'll apply it.

johannes

