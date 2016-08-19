Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbcHSJ5V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 05:57:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Pedersen\, Thomas" <twp@qca.qualcomm.com>
Cc: Guy Mishol <guym@ti.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wlcore: mesh: add zone time sync support
References: <20160808085706.22668-1-guym@ti.com>
        <1471538527.3432.21.camel@qca.qualcomm.com>
Date: Fri, 19 Aug 2016 12:57:10 +0300
In-Reply-To: <1471538527.3432.21.camel@qca.qualcomm.com> (Thomas Pedersen's
        message of "Thu, 18 Aug 2016 16:42:41 +0000")
Message-ID: <874m6h5bex.fsf@purkki.adurom.net> (sfid-20160819_115725_514053_E1BCB317)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Pedersen, Thomas" <twp@qca.qualcomm.com> writes:

> On Mon, 2016-08-08 at 11:57 +0300, Guy Mishol wrote:
>> Add zone time sync support for mesh role.
>> This allows to configure the mesh peer
>> master of each zone for time synchronization.
>
> What is this? mac80211 already tries to maintain TSF sync with mesh
> peers if get/set TSF ops are supported by the driver.

Yeah, and why use debugfs?

-- 
Kalle Valo
