Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4625 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2DQMww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 08:52:52 -0400
Message-ID: <4F8D6793.8090701@broadcom.com> (sfid-20120417_145258_413759_FFAEB07C)
Date: Tue, 17 Apr 2012 14:52:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Frank Kingswood" <frank@kingswood-consulting.co.uk>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic with brcm4313 (kernel 3.2.2)
References: <jgjoab$l54$1@dough.gmane.org>
 <4F2E6C34.6060903@broadcom.com>
 <4F2E9651.5020601@kingswood-consulting.co.uk>
 <4F8D471F.5070901@broadcom.com>
 <4F8D60FC.2090301@kingswood-consulting.co.uk>
In-Reply-To: <4F8D60FC.2090301@kingswood-consulting.co.uk>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 02:24 PM, Frank Kingswood wrote:
> Hi Arend,
>> I noticed in some log you sent that your regulatory domain is set to
>> GB, which makes sense. I submitted a patch [1] last week so could you
>> try that and let me know the results.
> [re-sending as plain text]
>
> Thanks for the update. Yes, my AP is on channel 13 so might be affected
> by this.
>
> That line is in brcms_c_wait_for_tx_completion()
>
> main.c,8006 WARN_ON_ONCE(timeout == 0);
>
> Would using another channel be any different for this?
>

I actually did not expect that warning to come up with the patch in 
place. So if you can try another channel in 1-11 range and let me know 
the result, I might be able to make some sense of it all.

Gr. AvS

