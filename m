Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402Ab3KFMgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:36:38 -0500
Message-ID: <1383741393.14307.43.camel@jlt4.sipsolutions.net> (sfid-20131106_133641_507207_522083E7)
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Johannes Berg <johannes@sipsolutions.net>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 06 Nov 2013 13:36:33 +0100
In-Reply-To: <1383740486.4256.65.camel@porter.coelho.fi>
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
	 <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
	 <201311061247.48777.sw@simonwunderlich.de>
	 <1383739343.4256.58.camel@porter.coelho.fi>
	 <1383739595.14307.41.camel@jlt4.sipsolutions.net>
	 <1383740486.4256.65.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 12:22 +0000, Coelho, Luciano wrote:

> > Well even then - the question is who would ever want to use and test
> > count<=1?
> 
> I guess the reason to have this is when you must evacuate the channel
> immediately, so you transmit the action frame and jump out.  If your
> beacon interval is long (for whatever reason), waiting for the next TBTT
> to announce the CSA may take longer than the time required to stop
> transmitting.

Fair point, so I guess we'd want to also test that :)

johannes

