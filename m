Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:18128 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYAJLwn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 06:52:43 -0500
Received: by py-out-1112.google.com with SMTP id u52so979741pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 03:52:40 -0800 (PST)
Message-ID: <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com> (sfid-20080110_115254_431577_1B995801)
Date: Thu, 10 Jan 2008 06:52:40 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200801062337.35904.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 6, 2008 5:37 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi John,
>
> Here is the 2.0.14 release of rt2x00. Again lots of bugfixes,
> and unfortunately we are still not there yet. I am afraid
> rt2500usb and rt61pci are lost causes for the 2.6.24 release,
> they are both broken, and I haven't figured out what is causing
> this.

Hi Ivo,

Sorry to be out of the loop, but what is wrong with rt61pci? It works
really really well for me, using John's "everything" branch.

Hmm. Looking at Linus's tree, I can see that rt61pci is missing at
least 1 critical fix from Mattias Nissler that has been in
wireless-2.6 for a long time now.

rt2x00: Allow rt61 to catch up after a missing tx report

I'd be pretty disappointed if we released 2.6.24 without this. It is a
simple fix for a really obnoxious problem (although one that triggers
rarely on my hardware).

There are also a bunch of antenna selection fixes that never went
upstream. These are required for my card to operate well at rates
greater than 1Mbit, even when fairly close to the AP.

But aside from these issues, the latest 2.6.24-rc7 seems ok for me. My
testing of it is somewhat limited, due to the terrible performance.
But I can associate, browse the web and run iperf tests.

-- 
Will Dyson
