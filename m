Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab1JGI47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 04:56:59 -0400
Subject: Re: [PATCH] mac80211: Allow NO_ACK flag overwrite for injected
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110929_112749_887836_A27DE080)
References: <1317288432-26380-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20110929_112749_887836_A27DE080)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 10:56:54 +0200
Message-ID: <1317977814.3988.10.camel@jlt3.sipsolutions.net> (sfid-20111007_105703_208036_20113F22)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-29 at 11:27 +0200, Helmut Schaa wrote:

> +		case IEEE80211_RADIOTAP_TX_FLAGS:
> +			txflags = le16_to_cpu(get_unaligned((__le16*)
> +						iterator.this_arg));
> +			if (txflags & IEEE80211_RADIOTAP_F_TX_NOACK)
> +				info->flags |= IEEE80211_TX_CTL_NO_ACK;
> +			break;
> +
>  		/*
>  		 * Please update the file
>  		 * Documentation/networking/mac80211-injection.txt

... :-)

johannes

