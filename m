Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab1E3Qqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 12:46:37 -0400
Subject: Re: [RFC 1/2] mac80211: add ieee80211_get_operstate() function
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1306418007-27573-1-git-send-email-eliad@wizery.com> (sfid-20110526_155333_039329_FF0E4F28)
References: <1306418007-27573-1-git-send-email-eliad@wizery.com>
	 (sfid-20110526_155333_039329_FF0E4F28)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 18:46:34 +0200
Message-ID: <1306773994.3448.9.camel@jlt3.sipsolutions.net> (sfid-20110530_184640_624634_BD9F866C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-05-26 at 16:53 +0300, Eliad Peller wrote:
> Add ieee80211_get_operstate() function to get the operstate
> of the netdevice.
> 
> This is needed for drivers that need to know when the interface
> is IF_OPER_UP (e.g. wl12xx), and block notifiers can't be used
> (e.g. because the interface is already IF_OPER_UP, like after
> resuming from suspend)

I don't see how this is necessary since the operstate can't change
during suspend?

johannes

