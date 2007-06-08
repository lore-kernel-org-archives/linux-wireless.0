Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58292 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763659AbXFHM1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 08:27:24 -0400
Message-ID: <46694B29.4060304@lwfinger.net>
Date: Fri, 08 Jun 2007 07:27:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>	 <20070607221939.444e9d74@griffin.suse.cz>	 <20070607222113.0f752bf8@griffin.suse.cz>	 <20070607222210.1a445cd7@griffin.suse.cz> <4668A7E5.3070500@lwfinger.net>	 <20070608105900.4c401e14@griffin.suse.cz> <1181293589.6533.25.camel@johannes.berg>
In-Reply-To: <1181293589.6533.25.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-06-08 at 10:59 +0200, Jiri Benc wrote:
> 
>>> I do not think this particular rate control algorithm is needed. A patch has been submitted that 
>>> will allow the user to use the SIOCSIWRATE ioctl to lock in a rate. In addition, a patch that 
>>> changes rc80211_simple to set the initial rate to the lowest supported value has also been 
>>> submitted. With these two alternatives, everything that this proposed module does is supported in 
>>> other ways.
>> Ok.
> 
> Actually, I'd vote for having this rate control algorithm anyway because
> it's basically a rate control algorithm template you can copy and
> modify. rc80211_simple is quite a bit more sophisticated over that.
> 
> johannes

If the comments include the idea that this is an template for the rate control mechanism, I withdraw 
my objection.

Larry

