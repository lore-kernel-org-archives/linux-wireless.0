Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:38368 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0JJQxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 12:53:20 -0400
Subject: Re: Release of Maranello firmware source code for Broadcom cards
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=utf-8
From: francesco.gringoli@ing.unibs.it
In-Reply-To: <AANLkTika70YCWU8eG5QHO+Bdf5XakEOg_b+UJdgCG4A0@mail.gmail.com>
Date: Sun, 10 Oct 2010 18:53:19 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, Bo Han <bohan@cs.umd.edu>
Message-Id: <E338C554-ADF5-490D-825D-E04D295664F0@ing.unibs.it>
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it> <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it> <AANLkTika70YCWU8eG5QHO+Bdf5XakEOg_b+UJdgCG4A0@mail.gmail.com>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Oct 10, 2010, at 4:47 PM, Rafał Miłecki wrote:

> 2010/10/10  <francesco.gringoli@ing.unibs.it>:
>> Hello there,
>> 
>> we released the source code of the Maranello firmware and all the
>> necessary kernel patches. It was tested on Broadcom 4318/4306 pci
>> cards on PC architecture. Find all the necessary files browsing from
>> 
>> http://www.ing.unibs.it/openfwwf
>> 
>> or go directly here
>> 
>> http://www.cs.umd.edu/projects/maranello
>> 
>> 
>> Maranello is an enhancement of the 802.11 DCF standard: it implements
>> a Partial Packet Recovery technique to retransmit only the corrupt
>> parts of failed packets. This reduces the airtime and contributes to
>> enhance the throughput. It was written starting from OpenFWWF5.2 by
>> adding a number of new features.
> 
> Hey, thanks for info!
> 
> Did you just add recovery feature to OpenFWWF 5.2 or did you improve
> basic OpenFWWF as well?
> 
> My 4318 with OpenFWWF 5.2 stops transmitting after few MB. Can
> Maranello contain any fix for this? I'll able to test this later next
> week.
No, I don't think so. OpenFWWF5.2 does not handle correctly fifo overflow conditions. We have a testing firmware that handles them (and that works perfectly on WRT54GL): I hope we can release it soon.

Kind regards,
-Francesco Gringoli


Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


