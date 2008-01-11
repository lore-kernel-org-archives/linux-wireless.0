Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.247]:19585 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbYAKSFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 13:05:36 -0500
Received: by ag-out-0708.google.com with SMTP id 23so834570agd.10
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 10:05:35 -0800 (PST)
Message-ID: <40f31dec0801111005r3beb4b4k3a4a5c17cef01298@mail.gmail.com> (sfid-20080111_180541_695742_5AD05CD7)
Date: Fri, 11 Jan 2008 20:05:35 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Romano Giannetti" <romanol@upcomillas.es>
Subject: Re: Testing ath5k driver
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1200073582.18380.1.camel@rukbat>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1200049360.12702.14.camel@rukbat>
	 <40f31dec0801110856r1d0e04f3i284afb2a3f64f8c1@mail.gmail.com>
	 <1200073582.18380.1.camel@rukbat>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/11, Romano Giannetti <romanol@upcomillas.es>:
>
>
> On Fri, 2008-01-11 at 18:56 +0200, Nick Kossifidis wrote:
> > 2008/1/11, Romano Giannetti <romanol@upcomillas.es>:
> > >
> > >
> > > [  312.999107] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> > > [  312.999141] PCI: Setting latency timer of device 0000:06:00.0 to 64
> > > [  312.999351] ath5k_pci 0000:06:00.0: registered as 'phy0'
> > > [  314.048568] ath5k phy0: failed to resume the MAC Chip
> > > [  314.048652] ACPI: PCI interrupt for device 0000:06:00.0 disabled
> > > [  314.048674] ath5k_pci: probe of 0000:06:00.0 failed with error -5
> > >
> >
> > It's a known bug in nic_wakeup, i've fixed it but patch is pending due
> > to testing. Problem is that even with that fix RF2425 doesn't tx/rx,
> > we are currently working with users to fix 2413/2414 support (radio
> > revision 0x56) so it'll take a while (tests etc) before we make this
> > work.
>
> Ok, understood. Please feel free to ping me if some change goes in and
> need testing.
>
> Thanks,
>         Romano
>

ACK, thanx for the report ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
