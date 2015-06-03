Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34138 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbFCR7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 13:59:02 -0400
Message-ID: <556F405D.2000909@lwfinger.net> (sfid-20150603_195907_658076_A9AC6629)
Date: Wed, 03 Jun 2015 12:58:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Scott Branden <sbranden@broadcom.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>, Andrew Kurn <kurn@sfu.ca>
Subject: Re: New USB ID 2001:3c25
References: <556E6000.90402@lwfinger.net> <6A6FBA3BBCB70741B2E7FD80BFDD32DB2B33CF50@SJEXCHMB10.corp.ad.broadcom.com>
In-Reply-To: <6A6FBA3BBCB70741B2E7FD80BFDD32DB2B33CF50@SJEXCHMB10.corp.ad.broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2015 12:50 PM, Scott Branden wrote:
> Hi Larry,
>
> There is no problem applying this patch to the stable tree.
> I didn't know it was my responsibility to inform the stable mailing list every time a patch is accepted
> in the latest kernel that could be applied to the stable tree?

It is not necessary; however, it is best if it gets called to their attention. 
I'm not sure if my E-mail was the reason, but your patch was applied to several 
of the stable versions this morning. The rest will probably follow soon.

The easy way to do this is to add "Cc: Stable <stable@vger.kernel.org>" to the 
original patch at submission. That way, stable gets the message as soon as it 
goes into mainline.

Thanks,

Larry


