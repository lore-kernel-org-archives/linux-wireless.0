Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:61025 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbbBQKuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 05:50:00 -0500
Message-ID: <54E31CD5.70901@broadcom.com> (sfid-20150217_115006_117399_00C6D85E)
Date: Tue, 17 Feb 2015 11:49:57 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Sebastien Bourdeauducq <sb@m-labs.hk>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac43241b4-sdio / Thinkpad Tablet 10 issues
References: <54E2E1CD.5020203@m-labs.hk>
In-Reply-To: <54E2E1CD.5020203@m-labs.hk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ lists

On 02/17/15 07:38, Sebastien Bourdeauducq wrote:
> Hi,
>
> have you been able to try out the driver on a brcm43241b4-sdio chip with
> the same revision as mine and reproduce the "HT avail timeout" bug? Just
> let me know if you would like me to test anything on my machine.

I received the vaio duo 13 laptop last friday. Unfortunately, it says:

chip 4324 rev 5 pmurev 17

So it is a one-off and not showing the issue you are seeing. Your issue 
seems to be due to failing firmware so you may need b5 firmware. I will 
look into this.

Thanks,
Arend

