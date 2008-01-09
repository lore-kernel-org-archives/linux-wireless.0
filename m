Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:39474 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYAILCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 06:02:08 -0500
Received: by rv-out-0910.google.com with SMTP id k20so189004rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 03:02:06 -0800 (PST)
From: Joonwoo Park <joonwpark81@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>, netdev@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 0/5] iwlwifi: iwl3945 fix races, getting rid of sleep from context
Date: Wed,  9 Jan 2008 20:01:51 +0900
Message-Id: <11998765114113-git-send-email-joonwpark81@gmail.com> (sfid-20080109_110214_104855_15DB1C0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
This patchset does fix iwl3945's races and some other stuff.
For now it works for just iwl3945 but if some of them is needed for iwl4965, I would work for it.

patch against 2.6.24-rc7

[PATCH 1/5] iwlwifi: iwl3945 flush interrupt mask
[PATCH 2/5] iwlwifi: iwl3945 synchronize interrupt and tasklet for down iwlwifi
[PATCH 3/5] iwlwifi: iwl3945 fix oops while pci remove
[PATCH 4/5] iwlwifi: iwl3945 eliminate sleepable task queue from context
[PATCH 5/5] iwlwifi: iwl3945 switch private workqueue to ieee80211->workqueue

Thanks,
Joonwoo
