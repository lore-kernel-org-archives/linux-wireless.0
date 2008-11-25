Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28241 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636AbYKYVmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 16:42:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 13:42:16 -0800
Message-ID: <492C7251.1040604@atheros.com> (sfid-20081125_224255_148944_9CCBDCBB)
Date: Tue, 25 Nov 2008 13:46:57 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Bluetooth is active on the channel where wifi  is also active
References: <492B833E.6050202@atheros.com> <EBB1336F-91C9-4ED6-B663-A1C83FF4A35D@holtmann.org> <492B9246.9010806@atheros.com> <0DF82B8B-D3CE-4347-98C3-F35A27829F50@holtmann.org> <492C5DEB.3050708@atheros.com>
In-Reply-To: <492C5DEB.3050708@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah, hci commands Write_AFH_Channel_Classification_Mode and
> Set_AFH_Host_Channel_Classification seem to have influence on
> afh channel map. But the problem is, I could not find a way
> to send these commands from hci utils. Is it possible to give
> standard hci commands from any of the hci utilities?. I tried
> 'cmd' option in hcitool but it does not seem to work.

Never mind, these hci commands are not handled in
hci_core.

Thanks,

Vasanth

