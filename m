Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58968 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1GRUt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 16:49:58 -0400
Message-ID: <4E249C71.70502@gnu.org> (sfid-20110718_225001_574591_63CC4245)
Date: Mon, 18 Jul 2011 16:49:53 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: correctly display longer chipsets ids
References: <1311021958-6758-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1311021958-6758-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/18/2011 04:45 PM, Rafał Miłecki wrote:
> Some of the newer Broadcom chipsets have longe names like BCM43224,
> BCM43225, etc. However Broadcom decided to keep using u16 for storing
> them. Use %X or %d depending on chip_id value to avoid BCMA8D8, etc.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>

Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
