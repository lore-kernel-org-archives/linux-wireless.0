Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elmendorf.ojctech.com ([64.198.255.10]:63824 "EHLO
	elmendorf.ojctech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZDPPsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:48:45 -0400
Date: Thu, 16 Apr 2009 10:37:24 -0500
From: David Young <dyoung@pobox.com>
To: radiotap@radiotap.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Proposal]TX flags
Message-ID: <20090416153724.GX25412@ojctech.com> (sfid-20090416_174847_884075_4F6A555F)
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 02:33:05AM +0200, G?bor Stefanik wrote:
> I propose the following suggested Radiotap features to be standardised:
> 
> * A new, 16-bit wide "TX flags" field (field number 15), containing
> the following flags:
>    - TX failed due to excessive retries,
>    - CTS-to-self protection,
>    - RTS/CTS-handshake,
>    - Frame shall not be ACKed ("No-ACK"), and
>    - Sequence number shall not be recalculated ("No-Seq").

Thanks.

FWIW, these assignments are compatible with NetBSD.  They appear to be
compatible with FreeBSD, too.

> If no one objects to this proposal in 7 days, I will resubmit it as a
> formal RFA, to allow eventual adoption.

Great!

Dave

-- 
David Young             OJC Technologies
dyoung@ojctech.com      Urbana, IL * (217) 278-3933
