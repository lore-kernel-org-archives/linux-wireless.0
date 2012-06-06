Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3044 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2FFLjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:39:17 -0400
Message-ID: <4FCF415B.9050307@broadcom.com> (sfid-20120606_133921_021452_0B3452C1)
Date: Wed, 6 Jun 2012 13:39:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 17/18] brcmsmac: fix read in write_phy_reg
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-18-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-18-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> This reverts a unintended change mad in commit.
> commit 4b006b11ca18995677c5f1cd03cc9c42fbe80693
> Author: Arend van Spriel <arend@broadcom.com>
> Date:   Thu Dec 8 15:06:54 2011 -0800
> 
>     brcm80211: smac: use bcma functions for register access in phy code

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

