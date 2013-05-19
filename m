Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1900 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab3ESIcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 04:32:06 -0400
Message-ID: <51988DF8.9000308@broadcom.com> (sfid-20130519_103212_914594_32835F0A)
Date: Sun, 19 May 2013 10:31:52 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonas Gorski" <jogo@openwrt.org>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: REGRESSION: v3.10-rc1: [PATCH 04/15] brcmsmac: remove
 brcms_bss_cfg->associated
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de>
 <1364085963-25940-5-git-send-email-hauke@hauke-m.de>
 <5197DC4F.7030503@broadcom.com>
 <CAOiHx=nJ=2zeN1wb=GTzk+hr=vYXAUvxpVAK7rt7M40PrvvBDg@mail.gmail.com>
In-Reply-To: <CAOiHx=nJ=2zeN1wb=GTzk+hr=vYXAUvxpVAK7rt7M40PrvvBDg@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2013 01:34 AM, Jonas Gorski wrote:
> Hauke's change made it possible for the code to return true, which
> looks at a first glance what might have been originally intended here,
> and the bug is somewhere else. But what do I know, I'm no Broadcom
> engineer;-)

Point taken :-) The function seems rather useless in brcmsmac, but I 
would like to keep it so we can use internal driver source as reference 
when adding power-save support.

Regards,
Arend

