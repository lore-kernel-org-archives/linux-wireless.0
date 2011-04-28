Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab1D1MJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 08:09:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: stable@kernel.org, kernel@lists.fedoraproject.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kyle McMartin <kmcmartin@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.38 0/4] iwlwifi: fix hw scan related problems 
Date: Thu, 28 Apr 2011 14:08:11 +0200
Message-Id: <1303992495-7337-1-git-send-email-sgruszka@redhat.com> (sfid-20110428_140918_364087_40A1DA6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset fixes several problems related with hw scanning
on 3945 (see patch 3 for details). It is intended to 2.6.38,
on older kernels software scanning does not work. All patches
are currently in Linus' tree.

