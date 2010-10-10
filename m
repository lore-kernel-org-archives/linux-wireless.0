Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40134 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab0JJOrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 10:47:49 -0400
Received: by qwf7 with SMTP id 7so1414320qwf.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 07:47:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it>
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it>
	<1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it>
Date: Sun, 10 Oct 2010 16:47:49 +0200
Message-ID: <AANLkTika70YCWU8eG5QHO+Bdf5XakEOg_b+UJdgCG4A0@mail.gmail.com>
Subject: Re: Release of Maranello firmware source code for Broadcom cards
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: francesco.gringoli@ing.unibs.it
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, Bo Han <bohan@cs.umd.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/10/10  <francesco.gringoli@ing.unibs.it>:
> Hello there,
>
> we released the source code of the Maranello firmware and all the
> necessary kernel patches. It was tested on Broadcom 4318/4306 pci
> cards on PC architecture. Find all the necessary files browsing from
>
> http://www.ing.unibs.it/openfwwf
>
> or go directly here
>
> http://www.cs.umd.edu/projects/maranello
>
>
> Maranello is an enhancement of the 802.11 DCF standard: it implements
> a Partial Packet Recovery technique to retransmit only the corrupt
> parts of failed packets. This reduces the airtime and contributes to
> enhance the throughput. It was written starting from OpenFWWF5.2 by
> adding a number of new features.

Hey, thanks for info!

Did you just add recovery feature to OpenFWWF 5.2 or did you improve
basic OpenFWWF as well?

My 4318 with OpenFWWF 5.2 stops transmitting after few MB. Can
Maranello contain any fix for this? I'll able to test this later next
week.

-- 
Rafał
