Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49692 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeDCJcq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 05:32:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: License info
References: <00c32ffb-9f20-f1a1-1054-ba57828b4db9@lwfinger.net>
Date: Tue, 03 Apr 2018 12:32:41 +0300
In-Reply-To: <00c32ffb-9f20-f1a1-1054-ba57828b4db9@lwfinger.net> (Larry
        Finger's message of "Thu, 29 Mar 2018 13:22:00 -0500")
Message-ID: <87a7ukk53a.fsf@kamboji.qca.qualcomm.com> (sfid-20180403_113249_999347_052F6244)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> What is your position regarding license information? Should the
> standard GPL-V2 boiler plate be replaced with
> "SPDX-License-Identifier: GPL-2.0" in wireless files?

I don't think replacing licenses with SPDX identifiers is very
important, but I can apply patches if someone wants to convert drivers.
And at the moment I'm not planning to require SPDX identifiers in new
files.

-- 
Kalle Valo
