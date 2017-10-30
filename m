Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.136]:50339 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdJ3CP4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 22:15:56 -0400
Message-ID: <59F68B40.8050506@rock-chips.com> (sfid-20171030_031616_371609_EE7E4464)
Date: Mon, 30 Oct 2017 10:15:28 +0800
From: jeffy <jeffy.chen@rock-chips.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pm@vger.kernel.org, tony@atomide.com,
        shawn.lin@rock-chips.com, briannorris@chromium.org,
        dianders@chromium.org, Xinming Hu <huxm@marvell.com>,
        linux-pci@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-acpi@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Will Deacon <will.deacon@arm.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        devicetree@vger.kernel.org, Ganapathi Bhat <gbhat@marvell.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Len Brown <lenb@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Caesar Wang <wxt@rock-chips.com>,
        Klaus Goger <klaus.goger@theobroma-systems.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH v10 0/7] PCI: rockchip: Move PCIe WAKE# handling into
 pci core
References: <20171027072612.26565-1-jeffy.chen@rock-chips.com> <1872710.P2f02irZl9@aspire.rjw.lan>
In-Reply-To: <1872710.P2f02irZl9@aspire.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafael,

thanks for your reply.

On 10/28/2017 05:07 PM, Rafael J. Wysocki wrote:
> Overall, I don't quite like the direction this is going into, but I need to
> have a deeper look.  Which may take some time, so please bear with me.
>
ok, i'll wait for your comments, thanks :)

> Thanks,
> Rafael
