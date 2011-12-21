Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:55522 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1LUVRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 16:17:15 -0500
Date: Wed, 21 Dec 2011 16:16:07 -0500 (EST)
Message-Id: <20111221.161607.1331587831465613240.davem@davemloft.net> (sfid-20111221_221731_553209_D8CD02E6)
To: tytso@mit.edu
Cc: johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111221211213.GB32561@thunk.org>
References: <20111213201752.GA5094@thunk.org>
	<20111214015959.GA6276@thunk.org>
	<20111221211213.GB32561@thunk.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Ted Ts'o" <tytso@mit.edu>
Date: Wed, 21 Dec 2011 16:12:13 -0500

> On Tue, Dec 13, 2011 at 08:59:59PM -0500, Ted Ts'o wrote:
>> On Tue, Dec 13, 2011 at 03:17:52PM -0500, Ted Ts'o wrote:
>> ... and the second problem I had with associating with EAP-TLS
>> encrypted SSID's was solved by Wey-Yi's patch: 
>> 
>> 	  iwlwifi: allow to switch to HT40 if not associated yet
>> 
>> ... found in the thread "iwlagn regression in v3.1.5"
>> 
>> So with these two patches applied, things are now stable for me.
> 
> It seems that fixes for these two issues haven't been pushed to Linus
> yet?  It would be nice if they could get pushed to mainline before 3.2
> ships, as opposed to being something that has to get fixed in the
> 3.2.X series....

It's in my queue to send to Linus.
