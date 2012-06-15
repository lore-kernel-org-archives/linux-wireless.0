Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20487 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab2FOHGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 03:06:20 -0400
Message-ID: <4FDADEE6.7070202@qca.qualcomm.com> (sfid-20120615_090628_884011_A1EB1E7B)
Date: Fri, 15 Jun 2012 10:06:14 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Peter Tam <peterctam@yahoo.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: Atheros 6K WiFi USB adaptors
References: <1339452813.67695.YahooMailNeo@web81603.mail.mud.yahoo.com> <1339454087.28071.YahooMailNeo@web81608.mail.mud.yahoo.com> <4FD9C1E7.7020409@qca.qualcomm.com> <1339687255.51353.YahooMailNeo@web81602.mail.mud.yahoo.com>
In-Reply-To: <1339687255.51353.YahooMailNeo@web81602.mail.mud.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,

please always CC linux-wireless and ath6kl-devel. I do not have the time
to give private support.

On 06/14/2012 06:20 PM, Peter Tam wrote:
>     Where is the htc_mbox.c & htc_pipe.c? Attached is my copy of Atheros code from the wireless community (dir.txt).

Like you mentioned in your other email you need to look at latest Linux
releases. The latest and greatest ath6kl is always available from
ath6kl.git:

http://wireless.kernel.org/en/users/Drivers/ath6kl

>     Is HTC means the smartphone making company HTC?

Heh, I have never realised that. A funny conflict :)

I was talking about Host/Target Communication, which is a protocol used
in our firmware. You can have different channels (or endpoints) and
encapsulate various payload, both control and data packets.

http://wireless.kernel.org/en/users/Drivers/ath6kl/architecture

Kalle
