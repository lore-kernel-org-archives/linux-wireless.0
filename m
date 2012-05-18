Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3249 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965588Ab2ERSeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 14:34:09 -0400
Message-ID: <4FB69612.6030304@broadcom.com> (sfid-20120518_203413_860022_AE0A5A7B)
Date: Fri, 18 May 2012 11:33:54 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>, linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: use vmalloc to allocate mem for the
 firmware
References: <1337365373-12418-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1337365373-12418-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2012 11:22 AM, Hauke Mehrtens wrote:
> The firmware is more than 300KB big and you should not use kmalloc for
> such big allocations. This allocation with kmalloc failed on my mips
> based device (BCM47186).
>
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---

You're right. We have noticed the kmalloc usage probelm but didn't have 
time to clean up the mess. Thanks for fixing this one.

Acked-by: Franky Lin <frankyl@broadcom.com>

Franky

