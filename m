Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2997 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab2KFR5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 12:57:11 -0500
Message-ID: <50994F65.8020908@broadcom.com> (sfid-20121106_185736_782077_232D149E)
Date: Tue, 6 Nov 2012 09:56:53 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: fix typo in CONFIG_BRCMISCAN
References: <1352067189-29017-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1352067189-29017-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2012 02:13 PM, Hauke Mehrtens wrote:
> The old ifdef CONFIG_BRCMFISCAN looks wrong to me and it makes more
> sense when CONFIG_BRCMISCAN is used.
> This patch was just compile tested by me, but not runtime tested.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks Hauke, nice catch.

Acked-by: Franky Lin <frankyl@broadcom.com>

John,

This is not necessary for 3.8 since the iscan code has been removed by a 
patch from Hante Meuleman in the train I sent yesterday. But it needs to 
be merged into 3.7 because iscan doesn't support scheduled scan. Sorry 
for the trouble.

Thanks,
Franky


