Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41184 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1GLPWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 11:22:39 -0400
Received: by vxb39 with SMTP id 39so3493724vxb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2011 08:22:38 -0700 (PDT)
Message-ID: <4E1C66BC.9080305@lwfinger.net> (sfid-20110712_172241_428568_1E164D1C)
Date: Tue, 12 Jul 2011 10:22:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ali Bahar <ali@internetdog.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: r8712u: Interface-state not fully tracked.
References: <1310483456-10543-1-git-send-email-ali@internetDog.org> <1310483456-10543-3-git-send-email-ali@internetDog.org>
In-Reply-To: <1310483456-10543-3-git-send-email-ali@internetDog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2011 10:10 AM, Ali Bahar wrote:
> padapter->bup is True when the interface has been
> brought Up. But it was not being reset when the
> interface is taken Down.
> This has not caused a known problem, as other
> state variables may be compensating for it. Never
> the less, it is now properly tracked.
>
> Signed-off-by: Ali Bahar<ali@internetDog.org>
> ---
>   drivers/staging/rtl8712/os_intfs.c |   14 ++++++++++++++
>   1 files changed, 14 insertions(+), 0 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

