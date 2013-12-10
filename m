Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54696 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3LJPg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 10:36:26 -0500
Message-ID: <52A734D9.3000506@candelatech.com> (sfid-20131210_163629_265269_59CEF499)
Date: Tue, 10 Dec 2013 07:35:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: split the if_limits and if_comb
References: <1386688840-12181-1-git-send-email-bartosz.markowski@tieto.com>
In-Reply-To: <1386688840-12181-1-git-send-email-bartosz.markowski@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2013 07:20 AM, Bartosz Markowski wrote:
> Split the interface limits and inteface combination,
> to reflect the 10.X capabilites (no P2P, no STA and 8 VAP).

My 10.X firmware works just fine with stations..I just tested up
to 32 of them.

Maybe add firmware IEs to explicitly advertise how many it can
support instead of setting one flag and making assumptions?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

