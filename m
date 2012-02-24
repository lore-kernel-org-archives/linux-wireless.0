Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1624 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab2BXJuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 04:50:07 -0500
Message-ID: <4F475D3C.8030809@broadcom.com> (sfid-20120224_105013_414853_E8EF9692)
Date: Fri, 24 Feb 2012 10:49:48 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcm80211: fmac: use correct firmware filename
References: <1330064571-4455-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1330064571-4455-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2012 07:22 AM, Rafał Miłecki wrote:
> Also don't use so generic BRCMF_USB_FW_NAME as we may need different
> firmwares in the future.
>

- Cc: Arend van Spriel<arend@broadcom.com>
+ Acked-by: Arend van Spriel <arend@broadcom.com>

> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---

Gr. AvS

