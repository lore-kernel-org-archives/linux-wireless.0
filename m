Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42130 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdCHQM3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 11:12:29 -0500
Date: Wed, 8 Mar 2017 17:10:25 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: wireless/atmel: remove time_t usage
Message-ID: <20170308161025.nxz6puyeo3ezwa43@piout.net> (sfid-20170308_171232_901567_594248E0)
References: <20170223161445.19200-1-alexandre.belloni@free-electrons.com>
 <20170308151340.9D6E360209@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170308151340.9D6E360209@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 08/03/2017 at 15:13:40 +0000, Kalle Valo wrote:
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> > last_qual never really holds a time. It only holds jiffies. Make it the
> > same type as jiffies.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> The title should start with "atmel:", I can fix that during commit.
> 

If you prefer, I can send a v2

-- 
Alexandre Belloni, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
