Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:17541
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751427AbcFTWLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 18:11:22 -0400
Subject: Re: [PATCH v2] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: <kvalo@codeaurora.org>
References: <1466457521-27662-1-git-send-email-igor.mitsyanko.os@quantenna.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>,
	Avinash Patil <avinashp@quantenna.com>,
	Dmitrii Lebed <dlebed@quantenna.com>,
	Sergei Maksimenko <smaksimenko@quantenna.com>,
	Sergey Matyukevich <smatyukevich@quantenna.com>,
	Bindu Therthala <btherthala@quantenna.com>,
	Huizhao Wang <hwang@quantenna.com>,
	Kamlesh Rath <krath@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <d67f5fa7-61ed-cdaf-c77c-e8ed2c2f4ee4@quantenna.com> (sfid-20160621_001141_535640_A551E808)
Date: Tue, 21 Jun 2016 01:11:06 +0300
MIME-Version: 1.0
In-Reply-To: <1466457521-27662-1-git-send-email-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sent to incorrect recipient email, please ignore, will resend.

On 06/21/2016 12:18 AM, igor.mitsyanko.os@quantenna.com wrote:
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
> ---
> Changelist V1->V2:
> 1. Get rid of confidentiality footer.
> 2. Rewrite qlink.h header to make it easier to use, add
> documentation to most of qlink.h definitions.
>

