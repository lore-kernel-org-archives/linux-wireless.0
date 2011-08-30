Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53551 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab1H3OGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 10:06:30 -0400
Date: Tue, 30 Aug 2011 17:03:43 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/20] ath6kl: Add functionality for starting AP mode
Message-ID: <20110830140343.GA8163@jouni.qca.qualcomm.com> (sfid-20110830_160634_472731_13A2984B)
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
 <1314620641-24257-2-git-send-email-jouni@qca.qualcomm.com>
 <4E5CA723.4040305@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E5CA723.4040305@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 12:02:27PM +0300, Kalle Valo wrote:
> On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> > +enum wfi_mgmt_frame_type {
> 
> Typo? Should it be wmi_mgmt_frame_type?

Yeah, fixed.

-- 
Jouni Malinen                                            PGP id EFC895FA
