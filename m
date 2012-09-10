Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42673 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab2IJM2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 08:28:05 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v3] p54: connect to 11w protected networks
References: <E1TA0re-00059m-CD@debian64.localnet>
	<1347036664.8913.1.camel@dcbw.foobar.com>
Date: Mon, 10 Sep 2012 15:28:00 +0300
In-Reply-To: <1347036664.8913.1.camel@dcbw.foobar.com> (Dan Williams's message
	of "Fri, 07 Sep 2012 11:51:04 -0500")
Message-ID: <87ehma5agf.fsf@purkki.adurom.net> (sfid-20120910_142809_016918_3C13F892)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Tue, 2012-09-04 at 15:19 +0200, Christian Lamparter wrote:
>> Previously, it was not possible to connect
>> to networks which requires 11w to be supported
>> by the stations.
>
> If at all possible if we can do this without module parameters, that
> would be great.  Otherwise how is userspace supposed to connect to a
> W-capable network without twiddling driver-specific module options,
> something we've tried really hard to not do?  Module options really
> aren't any different than private ioctls or IWPRIV commands...

Sure, and that's how it works with properly supported hardware. But p54
is so old that the user will need to buy newer hardware if he really
needs 11w support out-of-box. IMHO there's no point of making a huge
effort to add 11w support to older hardware, there are more important
things to fix in Linux wireless stack than that.

-- 
Kalle Valo
