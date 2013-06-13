Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2942 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab3FMIYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 04:24:19 -0400
Message-ID: <51B98145.7010908@broadcom.com> (sfid-20130613_102425_148503_EFBD6645)
Date: Thu, 13 Jun 2013 10:22:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: stable@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Greg KH" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] brcmfmac: Turn off ARP offloading when configured
 for AP.
References: <1370508957-12709-1-git-send-email-arend@broadcom.com>
 <1371092062.10688.36.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1371092062.10688.36.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2013 04:54 AM, Ben Hutchings wrote:
> On Thu, 2013-06-06 at 10:55 +0200, Arend van Spriel wrote:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> [backport of upstream commit b3657453f16a7b84eab9b93bb9a9a2901ffc70af]
> [...]
>
> You didn't say which version(s) this is for, but it certainly doesn't
> apply to 3.2.
>
> Ben.
>

I actually did the backport because I got notified the upstream commit 
did not apply to 3.9-stable (see [1]).

Gr. AvS

[1] http://mid.gmane.org/13704614501119@kroah.org

