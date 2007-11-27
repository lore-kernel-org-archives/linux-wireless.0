Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:55398 "EHLO
	will39.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbXK0BFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 20:05:06 -0500
Message-ID: <474B6CFB.2080208@willies.info> (sfid-20071127_010512_350178_987BB8EF)
Date: Tue, 27 Nov 2007 02:03:55 +0100
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: developers@islsm.org
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, kyle@mcmartin.ca,
	linux-wireless@vger.kernel.org
Subject: Re: [Developers] ISL3880IK crashes with 2.6.19.1 / .21.1
References: <46631BD2.20704@willies.info> <43e72e890711211713y1678bc9blf75e45dae4d74b8@mail.gmail.com> <4745EE3E.8090601@willies.info> <200711222235.44079.chunkeey@web.de>
In-Reply-To: <200711222235.44079.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
>> Hmmz, I wasn't aware that p54 doesn't support encryption or AP mode yet.
>> Is there any website/blog or something apart from linvilles commit log
>> where I can read about its progress?
>>
>> Funny thing is, I had a chat with Michael Wu because p54 was segfaulting
>> for me. Turned out that I was missing some crypto modules, which are
>> only needed for encryption I guess. Therefore I assumed encryption is
>> working.
>>
> "hardware encryption" does not work, since no one has implemented it.
> but the software encryption is always available...

Indeed, software encryption works like a charm (for me). This ISL3880
chip has a good range covered btw.

> The AP Mode is a pain... Beause the firmware of the device changes the beacon
> frames and does some accouting for the powersaving features...
> There're workarounds, but they'll probably break something else.

Sad to hear, but I guess there are many sad things to hear when talking
about wireless and open source.

How will AP Mode be realized once it's done? Via hostapd?


- Jan

