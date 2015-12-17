Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:46972 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751363AbbLQTLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 14:11:22 -0500
Message-ID: <1450379478.3430.11.camel@perches.com> (sfid-20151217_201128_152565_D3B67864)
Subject: Re: pull-request: mac80211 2015-12-15
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 17 Dec 2015 11:11:18 -0800
In-Reply-To: <1450356272.8247.31.camel@sipsolutions.net>
References: <1450182621.3356.12.camel@sipsolutions.net>
	 <20151216.183443.615368179590575650.davem@davemloft.net>
	 <1450356272.8247.31.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 13:44 +0100, Johannes Berg wrote:
> On Wed, 2015-12-16 at 18:34 -0500, David Miller wrote:
> >  
> > Something about your text encoding kept this from ending up
> > in patchwork for some reason.
> > 
> 
> Hm. I don't see anything special with this, seems to just be plain
> text
> 8bit transfer encoding.
> 
> Do you want me to watch out for things getting into patchwork in the
> future?
> 

Hey Johannes.

You seem to be using:

X-Mailer: Evolution 3.18.1-1 

which, to be overly technical, _sucks_.

The new composer for Evolution has way too many defects
to list.

It adds non-breaking spaces (NBSP) characters instead of
a standard ASCII space in various places.

Every version of Evolution since 3.14 is terrible at
sending text only messages.

3.12 works
