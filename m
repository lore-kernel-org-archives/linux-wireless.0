Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43498 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2FMAjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 20:39:09 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Message-ID: <20439.57561.33348.10834@gargle.gargle.HOWL> (sfid-20120613_023914_286030_01A49F66)
Date: Wed, 13 Jun 2012 06:07:45 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <linux-wireless@vger.kernel.org>
Subject: 3.5-rc wireless breakage
In-Reply-To: <20120612221431.2131d6fe@pyramind.ukuu.org.uk>
References: <20120612221431.2131d6fe@pyramind.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Cox wrote:
> Boot hangs and eventually the watchdog kicks in with the following trace
> 
> 
> __delay
> __const_udelay
> ar9003_get_pll_sqsum_dvc
> ath_hw_pll_work
> process_one_work
> ath_tx_complete_poll_work
> 
> 
> Platform is an HP Mini-210-4i
> 
> 
> Is this a known bug or does it warrant more digging ?

A patch has been posted for this:
http://marc.info/?l=linux-wireless&m=133951273906549&w=2

A version for 3.5 will be sent soon so that Linville can
pick it up.

Sujith
