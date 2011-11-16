Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49824 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab1KPLpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 06:45:07 -0500
Received: by vwl15 with SMTP id 15so533021vwl.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 03:45:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111116111702.GB2191@redhat.com>
References: <20111116100915.GA2191@redhat.com>
	<CAOZOX0WDQQeg4o5J9iQ_TpQgyYpTk5D3B4rpdTVR_4nGFVQ0wg@mail.gmail.com>
	<20111116111702.GB2191@redhat.com>
Date: Wed, 16 Nov 2011 12:45:06 +0100
Message-ID: <CAOZOX0XR8f9aoSHeFw95TPuUAe42-0mKwzkv_8aM6qtnP53pJA@mail.gmail.com> (sfid-20111116_124512_302027_205DFA3C)
Subject: Re: [PATCH] rt2800pci: handle spurious interrupts
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Amir Hedayaty <hedayaty@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 12:17 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Nov 16, 2011 at 11:14:41AM +0100, Ivo Van Doorn wrote:
>> > I changed rt2800pci only because get bug report for that device, not
>> > sure if similar changes are not needed for other rt2x00 PCI devices.
>>
>> The ticket mentiones that the end-result is a slow connection,
>> this is also a bug in older chipsets. So could you prepare a patch
>> for the other drivers as well?
> Yes, sure. Do you have handy links to bug reports that I could
> reference in the changelog?

Not really, I think most complains were on the mailinglist. There
are probably some bugreports, but I am not sure if that was the kernel
bugzilla, or on one of the distributions bugzilla's.

Ivo
