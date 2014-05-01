Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([74.45.170.26]:47489 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaEAPMV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 11:12:21 -0400
Message-ID: <5362644D.9070805@canonical.com> (sfid-20140501_171224_053643_081D99EC)
Date: Thu, 01 May 2014 09:12:13 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Nicolas Vaquero <nicovaq92@hotmail.com>
CC: Sven Eckelmann <sven@narfation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox> <53610B15.4000607@lwfinger.net> <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl> <5362475C.8040308@canonical.com> <536261D1.9070505@lwfinger.net>
In-Reply-To: <536261D1.9070505@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2014 09:01 AM, Larry Finger wrote:
> On 05/01/2014 08:08 AM, Tim Gardner wrote:
>> It looks like there is already a bug report in progress for this:
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1289429
>>
>> I'll attach the patch and have Joe build a test kernel.
> 
> Tim,
> 
> I agree that #1289429 is this bug. It seems that the problem also
> happens for 3.5.0-48-generic. If that is being supported, it also needs
> this patch.
> 
> Larry
> 
> 

Noted in the bug report. Thanks.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
