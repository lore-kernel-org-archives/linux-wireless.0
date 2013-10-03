Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53099 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab3JCMGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 08:06:17 -0400
Message-ID: <524D5DCE.80601@openwrt.org> (sfid-20131003_140621_249632_33F4F2C6)
Date: Thu, 03 Oct 2013 14:06:38 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Kevin Lo <kevlo@kevlo.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: rt2800lib: remove duplicate rf_vals for RF3053.
References: <524D2139.4000608@kevlo.org>
In-Reply-To: <524D2139.4000608@kevlo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.10.03. 9:48 keltezéssel, Kevin Lo írta:
> We already have rf_vals_3x with same values.  Hence rf_vals_3053 is removed
> in this patch.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

For completeness, the comment of rf_vals_3x should be updated to indicate that
it also supports RF3053. Otherwise the patch is fine.

-Gabor
