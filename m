Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([178.209.37.122]:38078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752077AbdC1QmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 12:42:15 -0400
Date: Tue, 28 Mar 2017 18:41:59 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alban <albeu@free.fr>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        m@kresin.me
Subject: Re: [PATCH 1/7] Documentation: dt: net: Update the ath9k binding for
 SoC devices
Message-ID: <20170328164159.GB29742@lunn.ch> (sfid-20170328_184343_937649_309B5CCC)
References: <1489439116-4233-1-git-send-email-albeu@free.fr>
 <2357006.NGKQYCh4BG@debian64>
 <20170328151837.GC3152@lunn.ch>
 <8622591.q4sXytZqXW@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8622591.q4sXytZqXW@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Oh, in that case you should probably go "all out" and ask on the 
> LKML to remove all of the ath9k and ath10k ahb work. From what I
> know all the "users" are running some sort of OpenWRT/LEDE or a 
> derivative. This is because Atheros/QCA provided a SDK based on
> OpenWRT.
> 
> Alban has been trying to convert the platform to device-tree
> and add them to the mainline for a while now:
>  
> https://patchwork.kernel.org/patch/6514551/
> 
> So, you are questioning this work as well.

Not at all. Ralph Sennhauser has been doing a great job of getting all
the Marvell devices into Mainline, and i help as much as i can, being
one of the Marvell SoC Maintainers.

I'm just saying, get a few boards which require these facilities into
the mainline, and then you have a much stranger base to argue from.

    Andrew
