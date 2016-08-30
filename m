Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13900 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753182AbcH3OTx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 10:19:53 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "engineering@keppy.com" <engineering@keppy.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: enable firmware crash dumps on the AR6004
Date: Tue, 30 Aug 2016 14:19:46 +0000
Message-ID: <871t16e34f.fsf@qca.qualcomm.com> (sfid-20160830_161957_366353_9EF40576)
References: <1472566303-32613-1-git-send-email-dan.kephart@lairdtech.com>
In-Reply-To: <1472566303-32613-1-git-send-email-dan.kephart@lairdtech.com>
        (engineering@keppy.com's message of "Tue, 30 Aug 2016 10:11:43 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

engineering@keppy.com writes:

> From: Dan Kephart <dan.kephart@lairdtech.com>
>
> The firmware crash dumps on the 6004 are the same as the 6003. Remove the
> statement guarding it from dumping on the 6004.  Renamed the
> REG_DUMP_COUNT_AR6003 to reflect support on both chips.
>
> Signed-off-by: Dan Kephart <dan.kephart@lairdtech.com>

I have a similar patch already on my queue:

https://patchwork.kernel.org/patch/9262289/

How does this differ from that? Please _always_ add a changelog so that
people know what has changed. Also remember to add "[PATCH v2]" to the
title.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#subject_name

--=20
Kalle Valo=
