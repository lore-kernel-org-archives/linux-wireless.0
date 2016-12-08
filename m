Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbcLHMxc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Dec 2016 07:53:32 -0500
Received: from potku.adurom.net (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD4AE606CC
        for <linux-wireless@vger.kernel.org>; Thu,  8 Dec 2016 12:53:29 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: wireless-drivers-next is closed for 4.10
References: <87oa0zwymr.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 08 Dec 2016 14:53:23 +0200
In-Reply-To: <87oa0zwymr.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 28 Nov 2016 14:57:16 +0200")
Message-ID: <87twae4m64.fsf@kamboji.qca.qualcomm.com> (sfid-20161208_135336_024874_F99FC21F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Linus said that he will release 4.9 either next Sunday or a week after,
> which means that the merge window is getting close. If there's something
> you absolutely need to have in 4.10 better send them NOW to not miss the
> window.

Dave closed net-next earlier than normally so wireless-drivers-next is
closed as well:

https://www.spinics.net/lists/netdev/msg409280.html

I had two patches pending in w-d-next but now I'll need to submit those
to net-next after the merge window and they will go to 4.11.

> Important bug fixes can go to 4.10 also after the merge window, but not
> new features.

wireless-drivers is open for bug fixes going to 4.10.

-- 
Kalle Valo
