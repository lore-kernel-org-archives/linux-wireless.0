Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56478 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbJGIOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 04:14:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: egrumbach@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: iwlwifi 2015-10-05
References: <1444044666.27220.5.camel@coelho.fi>
Date: Wed, 07 Oct 2015 11:14:41 +0300
In-Reply-To: <1444044666.27220.5.camel@coelho.fi> (Luca Coelho's message of
	"Mon, 05 Oct 2015 14:31:06 +0300")
Message-ID: <87a8rv14em.fsf@kamboji.qca.qualcomm.com> (sfid-20151007_101454_968369_7FD36196)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's a pull request for 4.3.  There are 8 patches, including a fix
> for a kernel panic, some serious PN programming issues, a thermal
> monitor fix and some new vendor IDs.
>
> Let me know if there are any issues.
>
> Luca.
>
> The following changes since commit dd5cdb48edfd34401799056a9acf61078d773f90:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2015-09-03 08:08:17 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-10-05
>
> for you to fetch changes up to dbf73d4a8bb8f4e1d1f3edd3be825692279e2ef3:
>
>   iwlwifi: mvm: flush fw_dump_wk when mvm fails to start (2015-10-05 14:04:16 +0300)
>
> ----------------------------------------------------------------
> * some fixes for PN key programming when entering D3;
> * fix for CSA when the AP is stopped during a channel switch;
> * fix firmware name for 3160 devices;
> * add some new PCI IDs for 7265 devices;
> * fix CT-kill entry;
> * fix kernel panic when a sysassert occurs in the init ucode flow;
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
