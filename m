Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59752 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1BRWpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 17:45:50 -0500
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297981882.23381.38.camel@dev.znau.edu.ua> (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297981882.23381.38.camel@dev.znau.edu.ua>
	 (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 23:45:45 +0100
Message-ID: <1298069145.23801.29.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 00:31 +0200, George Kashperko wrote: 
> +#define SSB_AI_BASE			0x18100000U /* base for AI registers */

#define MOON_EARTH_BASE 1337

That probably is my major point against this patchset. It just
merges things that don't belong to each other.
Is this the base on moon or earth?
If it's the earth base, why the hell do we prefix the define with MOON?

That naming confusion continues throughout the whole patchset.

SSB is end of life, so we should not try to support the new AI hardware
by making SSB AI aware. Just fork SSB and let legacy SSB die as the
existing hardware dies. It deserves it. Mercy killing for software!

_Currently_ it may look like a good idea to use one software base
for the two busses, but the cruft will hurt you in the future.
And the future begins one day after this hack was merged.

-- 
Greetings Michael.

