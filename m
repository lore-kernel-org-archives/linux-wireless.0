Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2IDIQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 04:16:32 -0400
Message-ID: <1346746629.3737.4.camel@jlt4.sipsolutions.net> (sfid-20120904_101638_139629_F08EB784)
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Tue, 04 Sep 2012 10:17:09 +0200
In-Reply-To: <503D9569.9080206@posedge.com>
References: <502E85D9.5050301@posedge.com>
	   <1345480718.4459.37.camel@jlt3.sipsolutions.net>
	   <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>
	   <50338E84.3050709@posedge.com>
	   <1345564421.10280.9.camel@jlt3.sipsolutions.net>
	   <5033CE76.6040306@posedge.com>
	   <1345619008.4635.3.camel@jlt3.sipsolutions.net>
	   <20120822090104.GA4959@redhat.com>
	   <1345626282.4635.8.camel@jlt3.sipsolutions.net>
	   <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com>
	  <1345809927.6991.0.camel@jlt3.sipsolutions.net>
	  <50377CD9.3090204@posedge.com>
	 <1345970386.3622.5.camel@jlt4.sipsolutions.net>
	 <503D9569.9080206@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-29 at 09:37 +0530, Mahesh Palivela wrote:

> To keep the backward compatibility, how about we still keep channel 
> type. New enum value "NL80211_CHAN_VHT" tells us to look at the new 
> channel_config structure. That way not every driver out there have to 
> change to use the new channel config structure. Let me know.

I think we should change drivers. Yes, this is possible, but overall
it'll just result in a mess, don't you think?

johannes

