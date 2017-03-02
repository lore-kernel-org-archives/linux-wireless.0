Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754228AbdCBJQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:16:44 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2017-03-02
Date: Thu, 02 Mar 2017 11:15:42 +0200
Message-ID: <87r32g9gzl.fsf@kamboji.qca.qualcomm.com> (sfid-20170302_101933_128497_E9919C25)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

only one patch this time, the new version of ath10k patch we reverted
earlier. I was supposed to send you this earlier but it got delayed
because I'm on vacation, so sorry about that. I'm hoping this is ok to
take also even the merge window is closed as the changes to the first
version of the patch are minimal.

Please let me know if there are any problems.

Kalle

The following changes since commit 8313064c2e75542201e557e2b496668811c2484a:

  Merge tag 'nfsd-4.11' of git://linux-nfs.org/~bfields/linux (2017-02-28 15:39:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2017-03-02

for you to fetch changes up to 1657b8f84ed9fc1d2a100671f1d42d6286f20073:

  ath10k: search SMBIOS for OEM board file extension (2017-03-02 10:48:41 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.11

Add back a fixed version of an ath10k patch which was reverted during
the merge window.

----------------------------------------------------------------
Waldemar Rymarkiewicz (1):
      ath10k: search SMBIOS for OEM board file extension

 drivers/net/wireless/ath/ath10k/core.c | 101 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |  19 +++++++
 2 files changed, 117 insertions(+), 3 deletions(-)

-- 
Kalle Valo
