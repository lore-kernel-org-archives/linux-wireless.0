Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59104 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbbLASwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 13:52:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Golan Ben-Ami <golan.ben.ami@intel.com>
Subject: Re: [PATCH 24/41] iwlwifi: mvm: move fw-dbg code to separate file
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
	<1448963947-24302-24-git-send-email-emmanuel.grumbach@intel.com>
Date: Tue, 01 Dec 2015 20:52:35 +0200
In-Reply-To: <1448963947-24302-24-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Tue, 1 Dec 2015 11:58:50 +0200")
Message-ID: <87r3j6gfws.fsf@kamboji.qca.qualcomm.com> (sfid-20151201_195245_736619_5203477A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Golan Ben-Ami <golan.ben.ami@intel.com>
>
> The fw debug functionality is big enough to warrant
> a separate file. Move existing related functions to the new file.
>
> Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[...]

>  intc-scripts/publishable-files                     | 203 ++++++

Added by accident?

-- 
Kalle Valo
