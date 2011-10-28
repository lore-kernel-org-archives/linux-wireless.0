Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38837 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab1J1LTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 07:19:04 -0400
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4EAA8FA1.1070003@qca.qualcomm.com> (sfid-20111028_131909_160254_C4F69872)
Date: Fri, 28 Oct 2011 14:18:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <linux-wireless@vger.kernel.org>,
	Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Subject: Re: [PATCH] Fix missing copy of frame contents to local buffer
References: <1319733356-31320-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1319733356-31320-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 07:35 PM, Aarthi Thiruvengadam wrote:
> The wpa_supplicant was receiving incorrect frame contents in the
> callback function that indicates the status of the frame transmitted.
> This patch fixes a missing copy of the frame contents to a local
> buffer. The local buffer keeps track of the last sent management frame.

Thanks, applied. But I changes the title to "ath6kl: fix missing copy of
action frame contents".

Kalle
