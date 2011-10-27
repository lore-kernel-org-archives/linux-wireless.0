Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39630 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1J0Hxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 03:53:41 -0400
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4EA90DFF.3070902@qca.qualcomm.com> (sfid-20111027_095353_630549_05E1BB32)
Date: Thu, 27 Oct 2011 10:53:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: add support for WPS
References: <1319567152-19789-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1319567152-19789-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 09:25 PM, Aarthi Thiruvengadam wrote:
> Add control flag CONNECT_WPS_FLAG if a WPS IE is present in the
> Association Request IEs. This flag is needed when the station must
> connect to a WPS-enabled AP.

Thanks, applied. There was a conflict due to multivif patches which I
fixed manually, please check that I didn't break anything.

Kalle
