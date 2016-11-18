Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbcKRLHr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 06:07:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [v7] mwifiex: parse device tree node for PCIe
References: <1479215662-631-1-git-send-email-akarwar@marvell.com>
        <20161117123920.E159F6162A@smtp.codeaurora.org>
        <20161117173824.GA129893@google.com>
Date: Fri, 18 Nov 2016 13:07:39 +0200
In-Reply-To: <20161117173824.GA129893@google.com> (Brian Norris's message of
        "Thu, 17 Nov 2016 09:38:25 -0800")
Message-ID: <87y40hkpvo.fsf@kamboji.qca.qualcomm.com> (sfid-20161118_120751_183368_C2804B5C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Thu, Nov 17, 2016 at 12:39:20PM +0000, Kalle Valo wrote:
>> Amitkumar Karwar <akarwar@marvell.com> wrote:
>> > From: Xinming Hu <huxm@marvell.com>
>> > 
>> > This patch derives device tree node from pcie bus layer framework.
>> > Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
>> > marvell-8xxx.txt) to accommodate PCIe changes.
>> > 
>> > Signed-off-by: Xinming Hu <huxm@marvell.com>
>> > Signed-off-by: Rajat Jain <rajatja@google.com>
>> > Reviewed-by: Brian Norris <briannorris@chromium.org>
>> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> 
>> You should CC the device tree list when making changes to the bindings.
>
> FWIW, Rajat had that right on v6...

Indeed. But please submit now v8 and also CC devicetree list. I need an
ack from them before I can apply this.

-- 
Kalle Valo
