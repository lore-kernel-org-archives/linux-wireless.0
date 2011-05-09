Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1EILde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 07:33:34 -0400
Subject: Re: [PATCH] mac80211: add a couple of trace event classes to
 reduce duplicated code
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1304940469-4978-1-git-send-email-coelho@ti.com>
References: <1304940469-4978-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 13:33:28 +0200
Message-ID: <1304940808.12202.0.camel@jlt3.sipsolutions.net> (sfid-20110509_133337_263752_F2791C78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 14:27 +0300, Luciano Coelho wrote:
> The functions drv_add_interface() and drv_remove_interface() print out
> the same values in the traces.  Combine the traces of these two
> functions into one event class to remove some duplicate code.
> 
> Also add a new class for functions drv_set_frag_threshold() and
> drv_set_rts_threshold().

Nice :)


> +DECLARE_EVENT_CLASS(local_value_evt,

Though I wonder if that might be better as "local_u32_evt"?

johannes

