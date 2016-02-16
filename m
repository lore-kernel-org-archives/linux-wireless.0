Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40442 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbcBPQCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 11:02:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-2016-02-16
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
Date: Tue, 16 Feb 2016 18:02:33 +0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA13D1A@hasmsx107.ger.corp.intel.com>
	(Emmanuel Grumbach's message of "Mon, 15 Feb 2016 11:57:38 +0000")
Message-ID: <874md8tzhi.fsf@kamboji.qca.qualcomm.com> (sfid-20160216_170242_970784_5BCC5F43)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> This is a pull request for 4.5. Apart from my RF-Kill fix, the patches are
> really small. My RF-Kill patch needed to move code around to avoid adding
> a forward declaration and on the way there were a few very trivial code style
> fixes, that were needed to make checkpatch happy.
>
> Let me know if you have issues, thanks!
>
>
> The following changes since commit 69c7fda40921c125eeeef6a827f6270ac6aa1baa:
>
>   iwlwifi: mvm: rs: fix TPC statistics handling (2016-01-26 16:03:35 +0200)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2016-02-15

Pulled, thanks.

-- 
Kalle Valo
