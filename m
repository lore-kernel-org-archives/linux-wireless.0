Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:44780 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030695AbXCCRkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2007 12:40:10 -0500
Date: Sat, 3 Mar 2007 09:40:08 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: question: /sys/class/net/*/wireless
Message-ID: <20070303174008.GA5081@jm.kir.nu>
References: <1172920691.4966.6.camel@johannes.berg> <1172921257.4966.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172921257.4966.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 03, 2007 at 12:27:37PM +0100, Johannes Berg wrote:
> And related to that issue, /proc/net/wireless.
> 
> Seeing that /sys/class/net/*/wireless has been around forever and offers
> the same information (actually, /proc/net/wireless tries to post-process
> quality values?? we can do that in sysfs too) I opt for killing it to
> minimize support requirements for cfg80211.
> 
> Unless somebody objects I intend to send a feature removal schedule
> patch soon.

Well, it could be added to the schedule, but taken into account how
widely used /proc/net/wireless and wireless extensions are in user space
programs, I don't think this should be removed anytime soon, if ever. I
would object removal for at least the next five years..

-- 
Jouni Malinen                                            PGP id EFC895FA
