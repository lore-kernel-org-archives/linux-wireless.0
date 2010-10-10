Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:45411 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab0JJRLR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 13:11:17 -0400
Subject: Re: Release of Maranello firmware source code for Broadcom cards
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: francesco.gringoli@ing.unibs.it
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, Bo Han <bohan@cs.umd.edu>
In-Reply-To: <335F2ADF-6921-4B5B-86C9-8DD348546B83@ing.unibs.it> (sfid-20101010_184934_490334_27D68101)
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it>
	 <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it>
	 (sfid-20101010_123116_260431_6CAA2A46) <1286714096.16309.10.camel@maggie>
	 <335F2ADF-6921-4B5B-86C9-8DD348546B83@ing.unibs.it>
	 (sfid-20101010_184934_490334_27D68101)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 19:11:12 +0200
Message-ID: <1286730672.16309.12.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 18:49 +0200, francesco.gringoli@ing.unibs.it
wrote:

> yes, the firmware works in AP mode, it is the basic AP mode implemented
> by OpenFWWF. And yes, both AP and STA implement partial packet recovery.
> We tested both directions and in our testbed (and most importantly with
> the hardware we have... unfortunately not all 4318/06 are equal :-( )
> it was stable and we never experienced crashes.

So it is possible to disable the Maranello feature in that firmware
(via SHM parameter or possibly also compiletime switch) to run it in
standard mode?
I think that would get the firmware base a lot more testing coverage.

-- 
Greetings Michael.

