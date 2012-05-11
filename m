Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8747 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab2EKIpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 04:45:31 -0400
Message-ID: <4FACD1A5.8090103@qca.qualcomm.com> (sfid-20120511_104536_849753_85876027)
Date: Fri, 11 May 2012 11:45:25 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [RFC] ath6kl: Add wow multicast firmware capability support
References: <1336679911-15763-1-git-send-email-ngangadh@qca.qualcomm.com>
In-Reply-To: <1336679911-15763-1-git-send-email-ngangadh@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
