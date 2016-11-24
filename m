Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound1.eu.mailhop.org ([52.28.251.132]:23130 "EHLO
        outbound1.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938647AbcKXMfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 07:35:39 -0500
Date: Thu, 24 Nov 2016 12:33:23 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Kalle Valo <kvalo@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
Message-ID: <20161124123323.GM2799@io.lakedaemon.net> (sfid-20161124_133543_091146_D70273AC)
References: <20161123191539.GF2799@io.lakedaemon.net>
 <20161123195120.GE14217@n2100.armlinux.org.uk>
 <20161123205917.GI2799@io.lakedaemon.net>
 <20161123211745.GF14217@n2100.armlinux.org.uk>
 <20161123214053.GJ2799@io.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123214053.GJ2799@io.lakedaemon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

On Wed, Nov 23, 2016 at 09:40:53PM +0000, Jason Cooper wrote:
> I'm running with ATH9K_DEBUGFS=y now.  If it goes a couple of days
> without crashing, I'll gin up a patch.

Well, it survived overnight, which it's never done before. :-) I'm
testing the relay_open() NULL patch now.

thx,

Jason.
