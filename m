Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:34724 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0JJMfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 08:35:01 -0400
Subject: Re: Release of Maranello firmware source code for Broadcom cards
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: francesco.gringoli@ing.unibs.it
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, Bo Han <bohan@cs.umd.edu>
In-Reply-To: <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it> (sfid-20101010_123116_260431_6CAA2A46)
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it>
	 <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it>
	 (sfid-20101010_123116_260431_6CAA2A46)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 14:34:56 +0200
Message-ID: <1286714096.16309.10.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 12:19 +0200, francesco.gringoli@ing.unibs.it
wrote: 
> Maranello is an enhancement of the 802.11 DCF standard: it implements
> a Partial Packet Recovery technique to retransmit only the corrupt
> parts of failed packets. This reduces the airtime and contributes to
> enhance the throughput. It was written starting from OpenFWWF5.2 by
> adding a number of new features.

Hey, that looks really cool. :)
So does this firmware work in AP and STA mode? I guess so, because it
seems you need support for the nonstandard enhancement on both STA
and AP.

-- 
Greetings Michael.

