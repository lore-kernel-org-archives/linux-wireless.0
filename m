Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:38115 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0JJQtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 12:49:25 -0400
Subject: Re: Release of Maranello firmware source code for Broadcom cards
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: francesco.gringoli@ing.unibs.it
In-Reply-To: <1286714096.16309.10.camel@maggie>
Date: Sun, 10 Oct 2010 18:49:25 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, Bo Han <bohan@cs.umd.edu>
Message-Id: <335F2ADF-6921-4B5B-86C9-8DD348546B83@ing.unibs.it>
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it> <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it> (sfid-20101010_123116_260431_6CAA2A46) <1286714096.16309.10.camel@maggie>
To: =?iso-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Oct 10, 2010, at 2:34 PM, Michael Büsch wrote:

> On Sun, 2010-10-10 at 12:19 +0200, francesco.gringoli@ing.unibs.it
> wrote: 
>> Maranello is an enhancement of the 802.11 DCF standard: it implements
>> a Partial Packet Recovery technique to retransmit only the corrupt
>> parts of failed packets. This reduces the airtime and contributes to
>> enhance the throughput. It was written starting from OpenFWWF5.2 by
>> adding a number of new features.
> 
> Hey, that looks really cool. :)
> So does this firmware work in AP and STA mode? I guess so, because it
> seems you need support for the nonstandard enhancement on both STA
> and AP.
Hello Michael,

yes, the firmware works in AP mode, it is the basic AP mode implemented by OpenFWWF. And yes, both AP and STA implement partial packet recovery. We tested both directions and in our testbed (and most importantly with the hardware we have... unfortunately not all 4318/06 are equal :-( ) it was stable and we never experienced crashes.

The most interesting point are the capabilities of this really simple boards: we were really surprised of how many things they can do (and I believe guys at Broadcom never imagined).

Kind regards,
-Francesco Gringoli

> 
> -- 
> Greetings Michael.
> 




Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


