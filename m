Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45251 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3ITFB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 01:01:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix tracing of ath10k_wmi_cmd
References: <1379576649-3947-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 20 Sep 2013 08:01:23 +0300
In-Reply-To: <1379576649-3947-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 19 Sep 2013 09:44:09 +0200")
Message-ID: <874n9ghysc.fsf@qca.qualcomm.com> (sfid-20130920_070131_381619_036E2EDD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> One of my recent patches broke tracing. kbuild
> test robot reported this issue.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Bad luck as I had accidentally tracing disabled on my test build. Patch
applied, but changed the commit log to:

commit 9e84f653ac16b718dd2305abe64a29bb3428621e
Author: Michal Kazior <michal.kazior@tieto.com>
Date:   Thu Sep 19 09:44:09 2013 +0200

    ath10k: fix tracing build for ath10k_wmi_cmd
    
    Commit be8b394390 ("ath10k: make WMI commands block by design") broke
    the build if CONFIG_ATH10K_TRACING was enabled.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
