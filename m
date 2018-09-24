Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbeIXNfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 09:35:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 01/11] qtnfmac_pcie: do not store FW name in driver state structure
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
        <20180924051246.13371-2-igor.mitsyanko.os@quantenna.com>
Date: Mon, 24 Sep 2018 10:34:36 +0300
In-Reply-To: <20180924051246.13371-2-igor.mitsyanko.os@quantenna.com> (Igor
        Mitsyanko's message of "Mon, 24 Sep 2018 05:13:24 +0000")
Message-ID: <87va6vqrg3.fsf@purkki.adurom.net> (sfid-20180924_093443_361782_2E5E7763)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com> writes:

> Firmware name is only needed at probe stage, no point in keeping it in
> driver state structure.
>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This is just cosmetics, but what's that "SO" in the From field? Do note
that if I apply these patches as is that will be stored also to git.

-- 
Kalle Valo
