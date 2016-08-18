Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754250AbcHSAyS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 20:54:18 -0400
Date: Thu, 18 Aug 2016 21:16:08 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Daniel Wagner <wagi@monom.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] wireless: Use complete() instead complete_all()
Message-ID: <20160818191608.GM3296@wotan.suse.de> (sfid-20160819_040401_458384_313194A7)
References: <1471525926-20384-1-git-send-email-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471525926-20384-1-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 18, 2016 at 03:12:04PM +0200, Daniel Wagner wrote:
> This series ignores all complete_all() usages in the firmware loading
> path. They will be hopefully address by Luis' sysdata patches [0].
> That leaves a couple of complete_all() calls.

I had not considered this as a gain, but glad to know the sysdata series
could help with RT as well, thanks for the clarification.

 Luis
