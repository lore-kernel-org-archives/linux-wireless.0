Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35114 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAYSd6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 13:33:58 -0500
Received: by mail-pf0-f196.google.com with SMTP id t12so6394943pfg.2
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jan 2018 10:33:58 -0800 (PST)
Date: Thu, 25 Jan 2018 10:33:55 -0800
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: Re: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX
 stall
Message-ID: <20180125183355.rpmajajr5exxcybb@ban.mtv.corp.google.com> (sfid-20180125_193402_064309_00DA2E99)
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
 <20180125071202.0F39560A60@smtp.codeaurora.org>
 <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 25, 2018 at 09:59:04AM +0000, Ganapathi Bhat wrote:
> > I can't find any commit with id c7dbdcb2a4e1, is it correct?
> Correct. Actually the commit id c7dbdcb2a4e1 is the PATCH [1/2] sent in this series.

What? Why would you introduce a bug and only fix it in the next patch?
Does that mean you should just combine the two? Or reverse the order, if
patch 2 doesn't cause problems on its own?

Brian
