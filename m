Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43244 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2B0Nuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 08:50:55 -0500
Message-ID: <4F4B8A38.6060606@qca.qualcomm.com> (sfid-20120227_145059_745366_92D1953E)
Date: Mon, 27 Feb 2012 15:50:48 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add unicast mgmt frame buffering
References: <1328752296-3801-1-git-send-email-ngangadh@qca.qualcomm.com>
In-Reply-To: <1328752296-3801-1-git-send-email-ngangadh@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 03:51 AM, Naveen Gangadharan wrote:
> PS buffering of unicast Action frames that are sent in a context
> of a BSS. In AP mode when the recepient station goes to powersave
> and PS_POLL flag is not set, we would buffer the frames. Send out
> unicast mgmt bufferred frame when PS_POLL is received.
> 
> This fixes a bug in P2P GO behavior when sending a GO Discoverability
> Request to a client that is in sleep mode.
> 
> Signed-off-by: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
> Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks, applied with some indentation fixes (which are new and not in
CodingStyle yet).

Kalle
