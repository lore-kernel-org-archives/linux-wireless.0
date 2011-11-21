Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2627 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755946Ab1KUSwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 13:52:33 -0500
Message-ID: <4ECA9DE0.4080202@broadcom.com> (sfid-20111121_195303_694535_FFB0D72F)
Date: Mon, 21 Nov 2011 10:52:16 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Thomas Meyer" <thomas@m3y3r.de>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: smac: Use kmemdup rather than
 duplicating its implementation
References: <1321569820.1624.289.camel@localhost.localdomain>
In-Reply-To: <1321569820.1624.289.camel@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2011 02:43 PM, Thomas Meyer wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
>
> Signed-off-by: Thomas Meyer<thomas@m3y3r.de>
> ---

Thanks Thomas.

Acked-by: Franky Lin <frankyl@broadcom.com>

Franky

