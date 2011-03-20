Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35060 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1CTXmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 19:42:40 -0400
Received: by iwn34 with SMTP id 34so5880689iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 16:42:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D866714.80503@lockie.ca>
References: <4D866714.80503@lockie.ca>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 21 Mar 2011 10:42:20 +1100
Message-ID: <AANLkTim_YELaSk4X4uRf_nsyAThK7SiMAq3rDD_MZVmb@mail.gmail.com>
Subject: Re: why would IRQ change?
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 07:44, James <bjlockie@lockie.ca> wrote:
> Is there a tool to list what devices are assigned what IRQ?
>
> This from an old kernel:
> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
> mem=0xffffc900017a0000, irq=18
>
> This is from today:
> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
> ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
> mem=0xffffc90001ba0000, irq=17

AFAIK, PCI interrupts numbers are just sequential numbers assigned by
Linux - there is no significance to them, they are just a number for
tracking which interrupt is assigned to which device - there is no
"IRQ17" or "IRQ18" anywhere in any actual hardware.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
