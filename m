Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:49768 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbbFRHDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 03:03:01 -0400
Date: Thu, 18 Jun 2015 12:32:35 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/10] Add QCA99X0 support
Message-ID: <20150618070231.GA4033@qca.qualcomm.com> (sfid-20150618_090309_615740_EAD227CF)
References: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
 <87wpz17d18.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87wpz17d18.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2015 at 09:20:51AM +0300, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:
> 
> > This patch set adds changes for QCA99X0 chip in pci probe,
> > Copy Engine init and firmware downloads. Since it is still
> > work in progress the support for this chip is not yet
> > advertised in pci device table.
> >
> > Vasanthakumar Thiagarajan (10):
> >   ath10k: Add a table to store hw specific values
> >   ath10k: Add new reg_address/mask to hw register table
> >   ath10k: Add hw register/values for QCA99X0 chip
> >   ath10k: Copy Engine related changes for QCA99X0
> >   ath10k: Make target cpu address to CE address conversion chip specific
> >   ath10k: Add chip reset sequence for QCA99X0
> >   ath10k: Extend CE src desc flags for interrupt indication
> >   ath10k: Fix BMI communication timeout for QCA99X0
> >   ath10k: Add support for code swap
> >   ath10k: Add BMI param value to execute otp to hw_param
> 
> These patches don't apply and don't have proper sha1 ids. Please rebase.
> And remember always to use ath.git master branch as the baseline, don't
> apply any custom patches because that will break 3-way merge.
> 
> Applying: ath10k: Add a table to store hw specific values
> Applying: ath10k: Add new reg_address/mask to hw register table
> Applying: ath10k: Add hw register/values for QCA99X0 chip
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/core.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0003 ath10k: Add hw register/values for QCA99X0 chip

Sorry about this. Im sending the rebased patches on top of ath.git master tot

Vasanth
