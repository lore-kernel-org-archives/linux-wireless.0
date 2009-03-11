Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46600 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbZCKOAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 10:00:34 -0400
Date: Wed, 11 Mar 2009 09:46:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Samuel Ortiz <samuel@sortiz.org>,
	Alina Friedrichsen <x-alina@gmx.net>
Subject: Re: configuring while interface is down
Message-ID: <20090311134640.GB8761@tuxdriver.com> (sfid-20090311_150112_540003_211ADDC0)
References: <1236774973.20266.13.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236774973.20266.13.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 01:36:13PM +0100, Johannes Berg wrote:
> Hi,
> 
> Alina raised an interesting point -- wext allows you to configure an
> interface while it is down, at least by convention. Some parameters for
> cfg80211 we reject while an interface is down, e.g. adding new stations,
> partly for technical reasons and partly because that doesn't make sense
> when the mode of interface isn't fixed.
> 
> For cfg80211's assoc/ibss calls, I think we should reject them outright
> when the interface is down, any objections?

I think that makes perfect sense.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
