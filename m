Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3572 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab2KSSfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:16 -0500
Message-ID: <50AA7BB4.3000209@broadcom.com> (sfid-20121119_193618_848467_B982C5F9)
Date: Mon, 19 Nov 2012 19:34:28 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	"Daniel Wagner" <wagi@monom.org>
Subject: Re: [PATCH v2 02/22] brcmsmac: Don't weight AMPDU packets in
 txfifo
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-3-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1352988492-21340-3-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2012 03:07 PM, Seth Forshee wrote:
> According to the comments this "reduces rate lag," but in reality the
> only way this value is used is for determining whether or not any frames
> remain to be transmitted. Therefore there's no reason for AMPDU packets
> to receive any weighting.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |   12 +++---------
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  |   19 +++++++++----------
>   drivers/net/wireless/brcm80211/brcmsmac/main.h  |    6 ++----
>   3 files changed, 14 insertions(+), 23 deletions(-)


