Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56552 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbbCWEuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 00:50:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-03-22
References: <1427044767.8611.4.camel@egrumbacBox>
Date: Mon, 23 Mar 2015 06:49:58 +0200
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox> (Emmanuel Grumbach's
	message of "Sun, 22 Mar 2015 17:19:28 +0000")
Message-ID: <87y4moe2rt.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_055010_711014_760A74BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Hi Kalle,
>
> A new round of fixes for 4.0. Most of the patches are also CCed to
> stable. Details in the tag. Thanks!
>
> The following changes since commit 4cd4b50cc2429294c23a1998c33fdfd804db0f37:
>
>   iwlwifi: mvm: BT Coex - fix a NULL pointer exception (2015-03-05 14:13:20 +0200)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-03-22
>
> for you to fetch changes up to 1f16ea294d2ef63013740f4c8539e430b6c12dff:
>
>   iwlwifi: mvm: remove WARN_ON for invalid BA notification (2015-03-19 15:43:11 +0200)
>
> ----------------------------------------------------------------
> * avoid panic with lots of IBSS stations
> * Fix dvm's behavior after suspend resume
> * Allow to keep connection after CSA failure
> * Remove a noisy by harmless WARN_ON
> * New device IDs
>
> ----------------------------------------------------------------

Thanks, pulled.

-- 
Kalle Valo
