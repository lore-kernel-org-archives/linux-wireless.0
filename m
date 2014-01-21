Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAUQSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:18:10 -0500
Message-ID: <1390321084.6199.65.camel@jlt4.sipsolutions.net> (sfid-20140121_171814_503053_12B710E2)
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information
 through get_station()
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 21 Jan 2014 17:18:04 +0100
In-Reply-To: <52DE9BAA.6020205@open-mesh.com>
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>
		 <1390302591-3352-2-git-send-email-antonio@meshcoding.com>
	 <1390320014.6199.61.camel@jlt4.sipsolutions.net>
	 <52DE9BAA.6020205@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-21 at 17:09 +0100, Antonio Quartulli wrote:

> > Actually this isn't expected throughput, but
> > wouldn't something like expected throughput make even more sense?
> 
> How should I obtain that if not with the previous operation (bitrate*prob)?

Minstrel actually has some tables for that, no? This would still just
only be the raw bitrate, not the actual throughput.

johannes


