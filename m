Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60003 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbbFJUBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 16:01:24 -0400
Message-ID: <1433966481.3145.17.camel@sipsolutions.net> (sfid-20150610_220130_916848_DE11F768)
Subject: Re: Allowing station to over-ride default VHT-oper element?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Jun 2015 22:01:21 +0200
In-Reply-To: <557896FC.8040204@candelatech.com>
References: <5578901C.60502@candelatech.com>
	  (sfid-20150610_212943_327894_FFEA768B) <1433966120.3145.15.camel@sipsolutions.net>
	 <557896FC.8040204@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 12:58 -0700, Ben Greear wrote:

> Ok, thanks for that..one less piece of work for me to do :)
> 
> From what I can tell, it *IS* ok to have an AP do VHT on 40Mhz though?

It may even be compelled to do so by the spec, since there could be
overlapping networks (see 10.39.2.)

johannes

