Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53132 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbC3GsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 02:48:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-03-30
References: <1427696735.7241.4.camel@egrumbacBox>
Date: Mon, 30 Mar 2015 09:47:54 +0300
In-Reply-To: <1427696735.7241.4.camel@egrumbacBox> (Emmanuel Grumbach's
	message of "Mon, 30 Mar 2015 06:25:36 +0000")
Message-ID: <871tk76kx1.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_084808_734651_68FADAF0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Hi Kalle,
>
> My last pull request for 4.0. This is a fix for a memory leak courtesy
> of Larry Finger (thanks to him). This patch has already been sent to the
> ML, so I won't reply to this pull request with git-send-email as I
> usually do.
> Please pull. Thanks.
>
>
> The following changes since commit 1f16ea294d2ef63013740f4c8539e430b6c12dff:
>
>   iwlwifi: mvm: remove WARN_ON for invalid BA notification (2015-03-19 15:43:11 +0200)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-03-30
>
> for you to fetch changes up to a71aaf66725e8fc02253a3bbea15d27e656434fe:
>
>   iwlwifi: Fix memory leak in iwl_req_fw_callback() (2015-03-24 11:40:36 +0200)
>
> ----------------------------------------------------------------
> * fix a memory leak: we leaked memory each time the module
> was loaded.
>
> ----------------------------------------------------------------

Thanks, pulled.

-- 
Kalle Valo
