Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:34662 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXFXTsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2007 15:48:25 -0400
Message-ID: <467E98C0.80304@warmcat.com>
Date: Sun, 24 Jun 2007 17:16:00 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH Try#14 1/4] mac80211: Monitor mode radiotap injection  docs
References: <20070624085757.244871712@warmcat.com>	<20070624090144.845936552@warmcat.com>	<1182677792.21939.130.camel@johannes.berg> <20070624125113.551ad748@logostar.upir.cz>
In-Reply-To: <20070624125113.551ad748@logostar.upir.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Sun, 24 Jun 2007 11:36:32 +0200, Johannes Berg wrote:
>> On Sun, 2007-06-24 at 09:57 +0100, andy@warmcat.com wrote:
>>> plain text document attachment (mac80211-docs-radiotap-usage.patch)
>>> Try #14
>>>  - Documented Jiri Benc's injection encapsulation method
> 
> Hm, replied to the other (kill mgmt interface) thread without looking
> through other mails :-(
> 
>> I still don't see the point since we've previously established that it
>> won't help on other interfaces (qdiscs, ...); for monitor interfaces #13
>> is enough and much simpler.
>>
>> I'd vote for applying #13.
> 
> Agreed.

Great, well let's go with that.

-Andy
