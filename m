Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53275 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbHFHbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 03:31:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2015-08-04
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Date: Thu, 06 Aug 2015 10:31:12 +0300
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Tue, 4 Aug 2015 20:36:54 +0000")
Message-ID: <87bnekzxdr.fsf@kamboji.qca.qualcomm.com> (sfid-20150806_093123_338340_EE9A0B44)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> It comes late, but this is the first pull request for 4.3.
> I have quite a bit for the next one that will come after this one.
>
> Please pull - thanks!
>
> emmanuel
>
> The following changes since commit e0456717e483bb8a9431b80a5bdc99a928b9b003:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> (2015-06-24 16:49:49 -0700)
>
> are available in the git repository at:
>
>  
> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> tags/iwlwifi-next-for-kalle-2015-08-04

BTW, it's a good idea to keep the tag name in the same line as the URL.
I almost missed the tag name because of the newline when copy pasting it
to my terminal :)

> for you to fetch changes up to 75118fdb63496e4611ab50380499ddd62b9de69f:
>
>   iwlwifi: mvm: clean up fw-api-scan.h (2015-08-04 21:29:37 +0300)
>
> ----------------------------------------------------------------
> * Deprecate -10.ucode
> * Clean ups towards multiple Rx queues
> * Add support for longer CMD IDs. This will be required by new
>     firmwares since we are getting close to the u8 limit.
> * bugfixes for the D0i3 power state
> * Add basic support for FTM
> * More random that doesn't really stand out
>
> ----------------------------------------------------------------

Thanks, pulled.

-- 
Kalle Valo
