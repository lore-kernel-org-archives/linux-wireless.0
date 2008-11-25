Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39499 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKYFym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 00:54:42 -0500
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <0DF82B8B-D3CE-4347-98C3-F35A27829F50@holtmann.org> (sfid-20081125_065446_655377_DFB11277)
From: Marcel Holtmann <marcel@holtmann.org>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <492B9246.9010806@atheros.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Bluetooth is active on the channel where wifi  is also active
Date: Tue, 25 Nov 2008 06:54:33 +0100
References: <492B833E.6050202@atheros.com> <EBB1336F-91C9-4ED6-B663-A1C83FF4A35D@holtmann.org> <492B9246.9010806@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasanth,

>> ou have an active Bluetooth connection, then you can check with
>> hcitool afh for the actual current channel mapping.
>
> Yeah, I checked this one, it is showing 0xffffffffffffffffff7f.
> Should we need to configure  with the appropriate channel mask
> so that it will skip 2.4 Ghz wifi channels?, I dont find any option
> to set this mask though.

maybe that is a bug in the new Broadcom chips. AFH should be auto- 
detecting WiFi channels, but there is a HCI command to manually  
influence this mapping.

Regards

Marcel

