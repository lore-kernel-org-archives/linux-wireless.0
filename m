Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbaAVOno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 09:43:44 -0500
Message-ID: <1390401820.4334.32.camel@jlt4.sipsolutions.net> (sfid-20140122_154347_634774_429F53A0)
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information
 through get_station()
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 15:43:40 +0100
In-Reply-To: <52DFD8A5.5090800@meshcoding.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
			 <1390302591-3352-2-git-send-email-antonio@meshcoding.com>
		 <1390320014.6199.61.camel@jlt4.sipsolutions.net>
		 <52DE9BAA.6020205@open-mesh.com>
	 <1390321084.6199.65.camel@jlt4.sipsolutions.net>
	 <52DEA10F.6090700@meshcoding.com> <52DFD8A5.5090800@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 15:41 +0100, Antonio Quartulli wrote:

> do you think that an API exporting the "expected throughput" would be a
> acceptable? At that point any RC algorithm can implement it the way it
> prefers.

I think that's a better choice, yes.

johannes

