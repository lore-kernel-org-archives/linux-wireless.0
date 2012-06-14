Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53277 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab2FNKuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 06:50:22 -0400
Message-ID: <4FD9C1E7.7020409@qca.qualcomm.com> (sfid-20120614_125025_286375_9743E29F)
Date: Thu, 14 Jun 2012 13:50:15 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Peter Tam <peterctam@yahoo.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: Atheros 6K WiFi USB adaptors
References: <1339452813.67695.YahooMailNeo@web81603.mail.mud.yahoo.com> <1339454087.28071.YahooMailNeo@web81608.mail.mud.yahoo.com>
In-Reply-To: <1339454087.28071.YahooMailNeo@web81608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,

On 06/12/2012 01:34 AM, Peter Tam wrote:
> 
> I thought I saw support code usb.c for that AR6000 wifi chip set. I 
> know there is extensive support for the SDIO interface version.

The USB version should work equally well. Are you having problems with
USB version?

> But on detail examination, the usb.c code is missing a lot of
> hif_ops interfce routines.

That's because of different HTC implementations. SDIO uses htc_mbox.c
and USB use htc_pipe.c and due to this there are differences in HIF
interface as well. I should document that better in the code.

Kalle
