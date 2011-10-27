Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60270 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab1J0IWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 04:22:48 -0400
Message-ID: <4EA914D2.9090601@qca.qualcomm.com> (sfid-20111027_102253_689202_984DCD48)
Date: Thu, 27 Oct 2011 11:22:42 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: Implement support for power parameter control
 from userspace
References: <1319597561-20454-1-git-send-email-rpanjwan@qca.qualcomm.com> <1319597561-20454-2-git-send-email-rpanjwan@qca.qualcomm.com>
In-Reply-To: <1319597561-20454-2-git-send-email-rpanjwan@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 05:52 AM, Rishi Panjwani wrote:
> In order to allow user space based control of power parameters, we use
> available debugfs infrastructure. With these features user can control
> power consumption by adjusting various sleep/wake up related parameters.
> The feature has been added for testing purposes. All 5 parameters are
> mandatory in correct order. They have to be written to the power_params
> file. These are:
> 
> 1) idle_period
> 2) no_of_pspoll
> 3) dtim_policy
> 4) tx_wakeup_policy
> 5) no_tx_to_wakeup
> 
> Example:
> 
> echo "200 1 0 1 1" > power_params

Applied, thanks. Again I added a vif index to the wmi call, please check
that.

Kalle
