Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35083 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1JMKaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 06:30:20 -0400
Message-ID: <4E96BDA3.5060001@qca.qualcomm.com> (sfid-20111013_123024_351399_3A2E6C86)
Date: Thu, 13 Oct 2011 13:29:55 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ath6kl: Fix endpoint_stats debugfs buffer length calculation
References: <20111011190821.GA29419@jouni.qca.qualcomm.com>
In-Reply-To: <20111011190821.GA29419@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2011 10:08 PM, Jouni Malinen wrote:
> The previous version did not really make much sense and the theoretical
> maximum length would be a bit longer. Calculate the length more
> accurately. In addition, there is no need to clear the buffer, so use
> kmalloc instead of kzalloc. For bonus points, add the forgotten
> cred_rpt_from_other value to the file.

Thanks, applied.

Kalle
