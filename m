Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab0KZNOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 08:14:19 -0500
Subject: Re: [PATCH] wl12xx: disable 11a channels when regulatory changes
 if 11a is not supported
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
References: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 14:14:17 +0100
Message-ID: <1290777257.3531.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-26 at 14:43 +0200, luciano.coelho@nokia.com wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
> 
> Instead of simply not scanning for the 11a channels when not supported by the
> hardware, disable the channels in reg_notify.  This centralizes the decision
> on whether to scan 5GHz channel in one place and allows userspace to know
> exactly which channels are in use.

Why are you advertising them to start with though?

johannes

