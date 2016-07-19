Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56119 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbcGSHjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 03:39:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna
 chipsets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Avinash Patil <avinashp@quantenna.com>,
	Dmitrii Lebed <dlebed@quantenna.com>,
	Sergei Maksimenko <smaksimenko@quantenna.com>,
	Sergey Matyukevich <smatyukevich@quantenna.com>,
	Bindu Therthala <btherthala@quantenna.com>,
	Huizhao Wang <hwang@quantenna.com>,
	Kamlesh Rath <krath@quantenna.com>,
	Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-Id: <20160719073946.F195A6120D@smtp.codeaurora.org> (sfid-20160719_093951_473091_7D879BF7)
Date: Tue, 19 Jul 2016 07:39:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:
> From: Avinash Patil <avinashp@quantenna.com>
> 
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
> 
> QSR10G is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs- one 5G and one 2G. 5G WMAC
> supports 160M, 8x8 configuration.
> FW supports 8 concurrent virtual interfaces on each WMAC.
> 
> Patch introduces 2 new drivers- qtnfmac.ko for interfacing with
> kernel/cfg80211 and qtnfmac_pcie.ko for PCIe bus interface.
> 
> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
> Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
> Signed-off-by: Huizhao Wang <hwang@quantenna.com>
> Signed-off-by: Kamlesh Rath <krath@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

I applied this to the pending branch so that kbuild bot can run build tests on
it. Let's see what it finds.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9188969/

