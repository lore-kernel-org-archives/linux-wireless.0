Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47861 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbbHMMAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 08:00:36 -0400
Message-ID: <1439467233.2114.24.camel@sipsolutions.net> (sfid-20150813_140051_132448_F66BEAB7)
Subject: Re: [PATCH 2/5] mac80211: Set txrc.bss to true for OCB interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>,
	linux-wireless@vger.kernel.org
Date: Thu, 13 Aug 2015 14:00:33 +0200
In-Reply-To: <1438783348-1427-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
References: <1438783348-1427-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-05 at 16:02 +0200, Bertold Van den Bergh wrote:
> To make mac80211 accept the multicast rate requested by the user the
> rate control should be told that it is operating in BSS mode.
> Without this, the default rate is selected in rate_control_send_low
> (!pubsta and !txrc->bss)
> 
Applied 1 and 2, although the 'bss' variable is somewhat misnamed I
guess.

johannes
