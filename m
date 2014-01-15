Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAONWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:22:22 -0500
Message-ID: <1389792139.4338.6.camel@jlt4.sipsolutions.net> (sfid-20140115_142224_589114_D75E1D22)
Subject: Re: [RFC 9/9] mac80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Jan 2014 14:22:19 +0100
In-Reply-To: <1389787494-7361-10-git-send-email-michal.kazior@tieto.com> (sfid-20140115_130933_655895_A9CC71F7)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-10-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140115_130933_655895_A9CC71F7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
> This implements a fairly simple multi-interface
> CSA. It doesn't support multiple channel
> contexts so it doesn't support multi-channel.

It seems that this also means that somewhere you need to advertise the
multi-switch feature. I guess you need that anyway, but this makes it
obvious.

johannes

