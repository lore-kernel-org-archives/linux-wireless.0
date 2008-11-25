Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58987 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYKYFqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 00:46:24 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 21:46:24 -0800
Message-ID: <492B9246.9010806@atheros.com> (sfid-20081125_064627_121303_BC165DCE)
Date: Mon, 24 Nov 2008 21:51:02 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Bluetooth is active on the channel where wifi  is also active
References: <492B833E.6050202@atheros.com> <EBB1336F-91C9-4ED6-B663-A1C83FF4A35D@holtmann.org>
In-Reply-To: <EBB1336F-91C9-4ED6-B663-A1C83FF4A35D@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> if you have an active Bluetooth connection, then you can check with
> hcitool afh for the actual current channel mapping.

Yeah, I checked this one, it is showing 0xffffffffffffffffff7f. 
Should we need to configure  with the appropriate channel mask 
so that it will skip 2.4 Ghz wifi channels?, I dont find any option 
to set this mask though.


Thanks,

Vasanth






