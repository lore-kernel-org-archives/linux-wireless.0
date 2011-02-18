Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:48186 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1BRW3M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 17:29:12 -0500
Subject: Re: [RFC] AI support (2/14 ssb helpers)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980484.23381.4.camel@dev.znau.edu.ua> (sfid-20110217_231646_647052_FFFFFFFFEFB25F2A)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297980484.23381.4.camel@dev.znau.edu.ua>
	 (sfid-20110217_231646_647052_FFFFFFFFEFB25F2A)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 23:29:09 +0100
Message-ID: <1298068149.23801.16.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 00:08 +0200, George Kashperko wrote: 
> 	const struct ssb_bus_ops *ops;
> +	const struct ssb_bus_helpers *helpers;

Uhm, well. "helpers"... . Seems like a pretty generic term.

I think this is still violating abstraction layering. Not as much
as your previous attempt, but still...

You're putting the ops structure that is supposed to abstract
the ssb bus into the ssb_device data structure. That should ring a bell.

-- 
Greetings Michael.

