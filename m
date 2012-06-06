Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1156 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab2FFKDs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:03:48 -0400
Message-ID: <4FCF2AF1.8020200@broadcom.com> (sfid-20120606_120352_055450_3FD8D0D1)
Date: Wed, 6 Jun 2012 12:03:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 13/18] brcmsmac: add some workarounds for other
 chips again
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-14-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-14-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> This adds some workarounds for the BCM4716, BCM47162, BCM43421, BCM5357
> and BCM6362 to the phy code again. This patch reverts the following

Has brcmsmac been tested for all these chips? At this moment I do not
have any bandwidth to do that. I am not too comfortable adding this code
without having some testing coverage. It was the reason to remove the
snippets from brcmsmac.

> patch expect the part with the workaround for the BCM43236, which is an
> usb chip and will be unsupported by brcmsmac.

'expect' should be 'except'. Indeed, BCM43236 is a fullmac usb chip and
as such supported by brcmfmac.

Gr. AvS

