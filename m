Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3CYJWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 05:22:12 -0400
Message-ID: <1364203327.8216.1.camel@jlt4.sipsolutions.net> (sfid-20130325_102216_102542_B4DF8FF6)
Subject: Re: [PATCH] cfg80211: Document update_ft_ies() cfg80211_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Mar 2013 10:22:07 +0100
In-Reply-To: <20130325091559.GA30599@w1.fi>
References: <20130325091559.GA30599@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-25 at 11:15 +0200, Jouni Malinen wrote:
> This was forgotten from the commit that added support for FT
> operations with drivers that implement SME.

Thanks, applied.

johannes

