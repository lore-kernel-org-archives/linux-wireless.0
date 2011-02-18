Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:56985 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab1BRWfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 17:35:10 -0500
Subject: Re: [RFC] AI support (8/14 ssb ssb_bus_detect routine)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297981247.23381.22.camel@dev.znau.edu.ua> (sfid-20110217_232921_076422_FFFFFFFFDFD95D3D)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297981247.23381.22.camel@dev.znau.edu.ua>
	 (sfid-20110217_232921_076422_FFFFFFFFDFD95D3D)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 23:35:07 +0100
Message-ID: <1298068507.23801.20.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-18 at 00:20 +0200, George Kashperko wrote: 
> +static const char *ssb_chipco_chiptype_name(struct ssb_bus *bus)
> +{
> +	switch (bus->chipco.chiptype) {
> +	case SSB_CHIPCO_SB:
> +		return "SB";
> +	default:
> +		return "UNKNOWN";
> +	}
> +}

The term "chip" doesn't seem to be appropriate here.
SSB (and probably AI, too. I don't know), does not have to be on-chip.
There are plenty of old SSB based boards where the SSB bus is wired
across the board.


-- 
Greetings Michael.

