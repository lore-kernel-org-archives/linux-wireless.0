Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52261 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbcDGQmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 12:42:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/10] rtl8xxxu: Change name of struct tx_desc to be more
 decriptive
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1459458522-28686-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Message-Id: <20160407164203.733FF6034D@smtp.codeaurora.org> (sfid-20160407_184209_995465_B78F0438)
Date: Thu,  7 Apr 2016 16:42:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> There are two major types of TX descriptor formats for the RTL parts,
> the old 32 byte descriptor, and the newer 40 byte descriptor used by
> the 8723bu, 8192eu, and 88xx series.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 10 patches applied to wireless-drivers-next.git:

dbb2896b485e rtl8xxxu: Change name of struct tx_desc to be more decriptive
33f372494842 rtl8xxxu: Rename TX descriptor bits to map them to 32/40 byte descriptors
169bc5cb0b81 rtl8xxxu: Correct txdesc40 gid definition
1df1de348572 rtl8xxxu: TXDESC_SHORT_GI is txdesc32 only
f3fc251162f9 rtl8xxxu: 8192eu uses txdesc40
931d9278259a rtl8xxxu: Update some register definitions
ba17d8247838 rtl8xxxu: Use enums for chip version numbers
af13faff851b rtl8xxxu: Identify 8192eu rev A/B parts correctly
91cbe4e73197 rtl8xxxu: Use correct H2C calls for 8192eu
a069caa3c30f rtl8xxxu: Do not set LDOA15 / LDOV12 on 8192eu

Kalle Valo
