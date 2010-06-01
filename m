Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab0FAUJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 16:09:51 -0400
Subject: Re: Association problems - again - comment
From: Johannes Berg <johannes@sipsolutions.net>
To: Jaroslav Fojtik <jafojtik@seznam.cz>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4C055FA2.23990.223BFA@jafojtik.seznam.cz>
References: <4C02E1CA.10757.239262@jafojtik.seznam.cz>
	 , <AANLkTimRxjfvS_6cR7ZN3yim3TO9GcPwJ59L3HZzpVmy@mail.gmail.com>
	 <4C055FA2.23990.223BFA@jafojtik.seznam.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:09:45 +0200
Message-ID: <1275422985.3634.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 21:29 +0200, Jaroslav Fojtik wrote:
> Dear Bob,
> 
> I have found a solution for my problem.
> 
> Patch from "Johannes Berg <johannes.berg@intel.com>" fixes a problem.
> 
> #Processing an association response could take a bit
> #of time while we set up the hardware etc. During that
> #time, the AP might already send a blockack request.

That makes no sense at all -- ath5k doesn't do aggregation. I guess it
probably just means that your problem is timing related.

johannes


