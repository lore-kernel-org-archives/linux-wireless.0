Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46097 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2EKTsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 15:48:25 -0400
From: "Gangadharan, Naveen" <ngangadh@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: RE: [RFC] ath6kl: Add wow multicast firmware capability support
Date: Fri, 11 May 2012 19:48:24 +0000
Message-ID: <972185EAC2B0F444829458AC91676645C5E138@nasanexd02d.na.qualcomm.com> (sfid-20120511_214829_679896_AC0398E2)
References: <1336679911-15763-1-git-send-email-ngangadh@qca.qualcomm.com>,<4FACD1A5.8090103@qca.qualcomm.com>
In-Reply-To: <4FACD1A5.8090103@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, I will send it again with the changes.

-Naveen
________________________________________
From: Valo, Kalle
Sent: Friday, May 11, 2012 1:45 AM
To: Gangadharan, Naveen
Cc: linux-wireless@vger.kernel.org; ath6kl-devel
Subject: Re: [RFC] ath6kl: Add wow multicast firmware capability support

On 05/10/2012 10:58 PM, Naveen Gangadharan wrote:
> Infrastructure to enable Multicast WOW support based on
> firmware capability added to the driver.This enables
> different customers or chips to control this feature based
> on firmware capability.
>
> kvalo: Firmware capability infrastructure for multicast wow feature.
>
> Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Looks good to me. But you should send this as "[PATCH]" so that I can
apply it.

Kalle
