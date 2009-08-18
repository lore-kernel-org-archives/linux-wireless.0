Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:54794 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZHRSTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:19:38 -0400
Subject: Re: [PATCH] mac80211: New stat counters for multicast and unicast
 forwarded frames
From: Daniel Walker <dwalker@fifo99.com>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	andrey@cozybit.com, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
In-Reply-To: <1250618340-32129-1-git-send-email-javier@cozybit.com>
References: <445f43ac0908181108g490934c1ib0c805859cba1e44@mail.gmail.com>
	 <1250618340-32129-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 11:19:45 -0700
Message-Id: <1250619585.4742.1929.camel@desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-08-18 at 10:59 -0700, Javier Cardona wrote:
> From: Daniel Walker <dwalker@fifo99.com>
> 
> This expands on the current fwded_frames stat counter which should be equal to
> the total of these two new counters.  The new counters are called "fwded_mcast"
> and "fwded_unicast".
> 
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---

Might have been nice for you to wait for me to review the new version
before adding my sign off , but it looks fine.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>

