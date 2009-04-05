Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1733 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZDECVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:21:07 -0400
Date: Sat, 4 Apr 2009 22:20:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	simon@farnz.org.uk
Subject: Re: [PATCH] ath5k: reduce exported channel list
Message-ID: <20090405022009.GA19600@hash.localnet> (sfid-20090405_042116_201261_CF3F1FC6)
References: <1238414729-29358-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238414729-29358-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 30, 2009 at 08:05:29AM -0400, Bob Copeland wrote:
> Claiming every available 5 ghz channel has a couple of negative
> side-effects: scanning takes a long time, and the channel list
> overflows the available buffer space for netlink commands,
> resulting in:
[...]
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

I forgot to include appropriate credit -- John, if you don't mind 
adding, that would be great, or I can resend.

Reported-by: Simon Farnsworth <simon@farnz.org.uk> 
Tested-By: Simon Farnsworth <simon@farnz.org.uk> 

-- 
Bob Copeland %% www.bobcopeland.com

