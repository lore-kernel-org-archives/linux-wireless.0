Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab0GURH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:07:58 -0400
Received: by bwz1 with SMTP id 1so354930bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 10:07:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100721133320.GB2355@tuxdriver.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
	<1279572443-14361-1-git-send-email-linville@tuxdriver.com>
	<AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
	<20100721133320.GB2355@tuxdriver.com>
Date: Wed, 21 Jul 2010 20:07:56 +0300
Message-ID: <AANLkTint5uT6PQ8pmEIVSoVYOSCZE5k-TGB1knwHtupw@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
From: Pauli Nieminen <suokkos@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 4:33 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Jul 21, 2010 at 08:08:41AM +0300, Pauli Nieminen wrote:
>> On Mon, Jul 19, 2010 at 11:47 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > The existing code seemed to be somewhat based on the datasheet, but
>> > varied substantially from the vendor-provided driver.  This mirrors the
>> > handling of the rtl8185 case from that driver, but still neglects the
>> > specifics for the rtl8180 hardware.  Those details are a bit muddled...
>> >
>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> > ---
>> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
>> >  1 files changed, 8 insertions(+), 3 deletions(-)
>
>> I tested this version of patch. Patch didn't apply cleanly for some
>> reason even tough when I mnauly typed it diff looks same.
>
> Please try the v2 version of the patch.  Some "back of the envelope"
> math suggests that the v2 version of the patch will give numbers more
> to your liking.
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>

But version 2 doesn't change the fact that driver is going to report
same signal strength even tough I know that only one wifi should have
100 % strength and others less than 50 %. There is only one router in
same room with me and all others routers are a lot more father away.
So driver is either reading wrong bits from hardware or my hardware is
broken.
