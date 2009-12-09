Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:63612 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758665AbZLIXXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 18:23:38 -0500
Message-ID: <4B203180.1010204@gmail.com>
Date: Thu, 10 Dec 2009 00:23:44 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
   in 2.6.32
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com> <4B1CCB81.5060104@klingt.org> <4B1D7A6B.1080606@gmail.com> <hfpa3v$5gj$1@ger.gmane.org>
In-Reply-To: <hfpa3v$5gj$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/09 23:59, Tim Blechmann wrote:
>> I can't reproduce any boot failures with the patch applied, although for me the rt2x00
>> drivers are compiled as modules. Can you provide some more information on the boot failure
>> that you see?
> 
> i am pretty sure, that i am experiencing the same issue as described
> here [1] with stack trace ...
> 
> [1] http://lkml.org/lkml/2009/12/8/207
> 

OK. Can you then test with powersaving disabled?

Just do iwconfig wlanX power off on the interface.

---
Gertjan.
