Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43156 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbeDFIHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:07:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for various chipsets
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
        <871sftemru.fsf@kamboji.qca.qualcomm.com>
        <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
        <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com>
Date: Fri, 06 Apr 2018 11:07:39 +0300
In-Reply-To: <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com> (Sebastian
        Gottschall's message of "Thu, 5 Apr 2018 22:00:43 +0200")
Message-ID: <87h8oosqpg.fsf@codeaurora.org> (sfid-20180406_100748_182869_B05C2A19)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> i have some comments about your check warnings.
> some of them are bogus. for instance they advise to use "unsigned int"
> instead of "unsigned". this might be better, but
> the original kernel header uses "unsigned" as api definition. so i
> decided to use the same declarations here.

Sure, but using "unsigned int" won't create any harm either.

> for the rest like whitespaces i will make a new version and remove them

You missed my comment in my earlier mail that I'll send the next
version. I have already fixed all the warnings so let me submit it. I'll
do also some other changes.

-- 
Kalle Valo
