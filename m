Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750793AbeELJKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:10:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: hw: make consistent usage of ATH10K_FW_DIR in paths
References: <20180509075633.3030-1-marcus.folkesson@gmail.com>
Date: Sat, 12 May 2018 12:10:21 +0300
In-Reply-To: <20180509075633.3030-1-marcus.folkesson@gmail.com> (Marcus
        Folkesson's message of "Wed, 9 May 2018 09:56:33 +0200")
Message-ID: <87in7tutmq.fsf@kamboji.qca.qualcomm.com> (sfid-20180512_111028_709747_1CC8B352)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Folkesson <marcus.folkesson@gmail.com> writes:

> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>

I don't like empty commit logs so I added this in the pending branch:

  ath10k: hw: make consistent usage of ATH10K_FW_DIR in paths

  For some reason not all entries used ATH10K_FW_DIR so fix that. No functional 
  changes.

-- 
Kalle Valo
