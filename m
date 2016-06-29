Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:41133 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbcF2Mfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 08:35:48 -0400
Date: Wed, 29 Jun 2016 08:35:19 -0400 (EDT)
Message-Id: <20160629.083519.1140782026978366981.davem@davemloft.net> (sfid-20160629_143554_602544_AE151350)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2016-06-29-v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <1467194567-19602-1-git-send-email-johannes@sipsolutions.net>
References: <1467194567-19602-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 29 Jun 2016 12:02:46 +0200

> Sorry to be sending a new pull request, but Felix had just submitted a
> fairly important fix and I decided I should send it on quickly.
> 
> Now thus we have two fixes, one for the mesh refcounting issue and one
> for an issue with the ethertype/length field being too long when it's
> used as a length, during A-MSDU decapsulation.
> 
> Let me know if there's any problem.

Pulled, thanks.
