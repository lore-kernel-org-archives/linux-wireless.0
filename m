Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61103 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbbAHMYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 07:24:55 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Message-ID: <54AE770C.4080006@qca.qualcomm.com> (sfid-20150108_132459_210060_746EE603)
Date: Thu, 8 Jan 2015 14:24:44 +0200
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 17/22] wil6210: add advanced interrupt moderation
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>	<1419320844-23989-18-git-send-email-qca_vkondrat@qca.qualcomm.com> <87mw5vt3fb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mw5vt3fb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2015 10:12 AM, Kalle Valo wrote:
> The number of module parameters feels a little excessive, especially
> when you add one more in the following patch. Is it really necessary for
> the user to configure all these? Why can't the driver pick good
> defaults?

Unfortunately, all these are really tunable parameters that impact 
performance.
I also realized it is too much. If we will find appropriate defaults for 
some parameters, not requiting tuning, I'll upload patch removing it.

Thanks, Vladimir
