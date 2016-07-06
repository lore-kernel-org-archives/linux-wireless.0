Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33646 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbcGFLyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 07:54:03 -0400
Message-ID: <1467806037.25088.26.camel@coelho.fi> (sfid-20160706_135407_230604_ACCB47BC)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>
Date: Wed, 06 Jul 2016 14:53:57 +0300
In-Reply-To: <1467805908.26633.1.camel@sipsolutions.net>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
	 <1467721394-8195-4-git-send-email-luca@coelho.fi>
	 <1467805908.26633.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 3/7] cfg80211: handle failed skb allocation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-07-06 at 13:51 +0200, Johannes Berg wrote:
> On Tue, 2016-07-05 at 15:23 +0300, Luca Coelho wrote:
> > From: Gregory Greenman <gregory.greenman@intel.com>
> > 
> > Handle the case when dev_alloc_skb returns NULL.
> > 
> Applied. A Fixes: tag would have been nice, but I added one :)

Oh, did I miss that one? Sorry.  I tried to add "Fixes" to all the
relevant patches I sent... but probably missed some.

--
Luca.
