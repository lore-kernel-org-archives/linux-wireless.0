Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64314 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758729Ab1D0Rxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 13:53:46 -0400
Received: by pvg12 with SMTP id 12so1307598pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 10:53:45 -0700 (PDT)
Message-ID: <4DB85824.9090202@lwfinger.net> (sfid-20110427_195349_744703_E393EBB2)
Date: Wed, 27 Apr 2011 12:53:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: pci: early fix for SPROM core index
References: <1303921294-6591-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1303921294-6591-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/2011 11:21 AM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> This was documented in:
> Message-ID:<4BB81CAD.10602@lwfinger.net>
> ---
>   drivers/ssb/driver_pcicore.c |   12 ++++++++++++
>   1 files changed, 12 insertions(+), 0 deletions(-)

ACK.

Larry
