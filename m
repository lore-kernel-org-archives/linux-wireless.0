Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38688 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbaHMKFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 06:05:15 -0400
Message-ID: <1407924311.21220.28.camel@jlt4.sipsolutions.net> (sfid-20140813_120526_003700_E25D7033)
Subject: Re: About the TSFT field
From: Johannes Berg <johannes@sipsolutions.net>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Aug 2014 12:05:11 +0200
In-Reply-To: <53EB355E.6090508@create-net.org> (sfid-20140813_120259_727542_9924FF23)
References: <53EB355E.6090508@create-net.org>
	 (sfid-20140813_120259_727542_9924FF23)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-13 at 11:52 +0200, Roberto Riggio wrote:

> As far as I've understood the TSFT is generated from the MAC,
> however I do not know to which instant the TSFT is relative,
> the first bit of the MAC payload, the beginning of the PLCP,
> etc.

It's documented in the radiotap spec, but not all drivers are really
doing the right thing here.

> Also I do not know from which reference the TSFT is generated,
> I mean two AP synchronized using NTP will have consistent
> TSFT, which kind of error should I expect?

It's purely local time - no synchronisation happens.

johannes

