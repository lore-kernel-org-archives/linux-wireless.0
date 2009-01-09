Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:14355 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbZAIB2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 20:28:42 -0500
Received: by wf-out-1314.google.com with SMTP id 27so9575321wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 17:28:41 -0800 (PST)
Subject: Re: Thoughts about the b43 RNG
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200901090211.03937.mb@bu3sch.de>
References: <200901090211.03937.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 17:28:39 -0800
Message-Id: <1231464519.5715.32.camel@brick> (sfid-20090109_022855_239051_DF872052)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-09 at 02:11 +0100, Michael Buesch wrote:
> I was doing some random tests on the b43 hardware RNG.
> These are the results.
> 
> I patched the firmware to not access the RNG register anymore.
> The unpatched firmware does two things. It reads the RNG register to get random values
> and it writes 0 to the register every now and then for whatever reason.
> Both reads and writes were patched out during my test. So the driver was
> the only one accessing the RNG.
> 
> This is the result of reading a few bytes from the RNG with the patched fw:

> I'm not sure about this. There aren't any obvious patterns.
> But maybe I'm just blind. Does somebody else see some pattern or
> has some RNG test program to recognize such patterns?
> 
> So let's do another test. Let's modify the previous test to
> write 0xFFFF instead of 0:
> 

NIST has a pretty good test suite I think.

Harvey

