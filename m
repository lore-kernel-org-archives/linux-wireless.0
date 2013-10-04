Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:24763 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751600Ab3JDBmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 21:42:14 -0400
Message-ID: <524E1CB8.3040004@kevlo.org> (sfid-20131004_034220_570537_CB21BBD4)
Date: Fri, 04 Oct 2013 09:41:12 +0800
From: Kevin Lo <kevlo@kevlo.org>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: rt2800lib: remove duplicate rf_vals for RF3053.
References: <524D2139.4000608@kevlo.org> <524D5DCE.80601@openwrt.org>
In-Reply-To: <524D5DCE.80601@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> 2013.10.03. 9:48 keltezéssel, Kevin Lo írta:
>> We already have rf_vals_3x with same values.  Hence rf_vals_3053 is removed
>> in this patch.
>>
>> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> For completeness, the comment of rf_vals_3x should be updated to indicate that
> it also supports RF3053. Otherwise the patch is fine.

Ok, I'll send an updated patch, thanks.

>
> -Gabor
>

     Kevin
