Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab2AKS7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 13:59:48 -0500
Subject: Re: [PATCH 1/2] wireless: Save original maximum regulatory
 transmission power for the calucation of the local maximum transmit power
From: Johannes Berg <johannes@sipsolutions.net>
To: Hong Wu <Hong.Wu@dspg.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <5EFF534737810441B0F97C2792E49C2DD20371@ILMAIL01.dspg.com>
References: <5EFF534737810441B0F97C2792E49C2DD20371@ILMAIL01.dspg.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jan 2012 19:59:45 +0100
Message-ID: <1326308385.3417.11.camel@jlt3.sipsolutions.net> (sfid-20120111_195952_106742_2DFBBA5D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-11 at 20:33 +0200, Hong Wu wrote:
> The local maximum transmit power for a channel is defined as the maximum
> regulatory transmission power minus the local power constraint specified
> for the channel in the Power Constraint element. (7.3.2.15 IEEE80211 2007)

I have a feeling that looking at the code I understand what you're
trying to fix, but please explain it better.

johannes

