Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48854 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbcIIMMs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:12:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k: remove repetitions of mask array size
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1460818477-22785-1-git-send-email-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <ath9k-devel@lists.ath9k.org>, Bob Copeland <me@bobcopeland.com>
Message-ID: <3c2c0881c96d49f490fa04c869c5bb4d@euamsexm01a.eu.qualcomm.com> (sfid-20160909_141421_203330_52192864)
Date: Fri, 9 Sep 2016 14:12:41 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> The constant "123", which is the number of elements in
> mask_m / mask_p, is repeated several times in this function.
> 
> Replace memsets with array initialization, and replace a loop
> conditional with ARRAY_SIZE() so that we don't repeat ourselves.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> Reviewed-by: Oleksij Rempel <linux@rempel-privat.de>

Thanks, 1 patch applied to ath-next branch of ath.git:

b5182e157d3a ath9k: remove repetitions of mask array size

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/8861641/
