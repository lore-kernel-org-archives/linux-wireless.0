Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35130 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdC1RJF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 13:09:05 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Alban <albeu@free.fr>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        m@kresin.me
Subject: Re: [PATCH 1/7] Documentation: dt: net: Update the ath9k binding for SoC devices
Date: Tue, 28 Mar 2017 19:09:00 +0200
Message-ID: <5695498.VIMxqRcvSt@debian64> (sfid-20170328_191027_459673_5DDDFE8B)
In-Reply-To: <20170328164159.GB29742@lunn.ch>
References: <1489439116-4233-1-git-send-email-albeu@free.fr> <8622591.q4sXytZqXW@debian64> <20170328164159.GB29742@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 28, 2017 6:41:59 PM CEST Andrew Lunn wrote:
> > Oh, in that case you should probably go "all out" and ask on the 
> > LKML to remove all of the ath9k and ath10k ahb work. From what I
> > know all the "users" are running some sort of OpenWRT/LEDE or a 
> > derivative. This is because Atheros/QCA provided a SDK based on
> > OpenWRT.
> > 
> > Alban has been trying to convert the platform to device-tree
> > and add them to the mainline for a while now:
> >  
> > https://patchwork.kernel.org/patch/6514551/
> > 
> > So, you are questioning this work as well.
> 
> Not at all. Ralph Sennhauser has been doing a great job of getting all
> the Marvell devices into Mainline, and i help as much as i can, being
> one of the Marvell SoC Maintainers.
> 
> I'm just saying, get a few boards which require these facilities into
> the mainline, and then you have a much stronger base to argue from.

I was arguing not to deprecate "qca,no-eeprom" property.

based on this quote from Linus' <https://lkml.org/lkml/2016/6/16/995>:
|if a new interface is truly more flexible, then it should be able
|to implement the old interface with no changes, so that drivers
|shouldn't need to be changed/upgraded.

what stronger point to do you want?

Thanks,
Christian
