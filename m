Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8658 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab2HQHf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 03:35:59 -0400
Message-ID: <502DF458.8080900@qca.qualcomm.com> (sfid-20120817_093604_754945_5F763839)
Date: Fri, 17 Aug 2012 10:35:52 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <drwho@infidigm.net>
CC: <bkamatch@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl: Add support for AR6004 hardware version 1.3
References: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>    <4FFC08C5.2050606@qca.qualcomm.com>    <71781241c331fcbb5687068ddc6bbb06.squirrel@www.infidigm.net>    <4FFD7621.5020207@qca.qualcomm.com>    <19811dfd94388fb6406373822974cee7.squirrel@www.infidigm.net>    <5005956F.3010300@qca.qualcomm.com>    <5007D509.4050809@qca.qualcomm.com> <5cf4071422583bd246540992af9f7582.squirrel@www.infidigm.net>
In-Reply-To: <5cf4071422583bd246540992af9f7582.squirrel@www.infidigm.net>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jon,

sorry for the late answer, I was again on vacation.

On 07/20/2012 11:09 PM, drwho@infidigm.net wrote:
> Kalle,
> 
> Gave the firmware a try using your ath6kl-next branch (pulled yesterday). 
> I can connect and move data to open networks only.  WPA connections appear
> to keep trying to associate over and over at these states....
> 
> ASSOCIATED -> 4WAY_HANDSHAKE
> 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
> 
> wpa_supplicant log attached.  I tried a couple of routers / APs.

There's a developer working on this issue. I don't know when he will
send the fix but let's hope that it will happen soon.

Thanks for the report, keep them coming.

Kalle
