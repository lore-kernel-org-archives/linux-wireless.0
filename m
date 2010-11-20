Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54122 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0KTXFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 18:05:54 -0500
Received: by vws13 with SMTP id 13so2988798vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 15:05:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimEMtt1JJerTzG4-X_Ez83MxtU_52wVQ_xJC8N3@mail.gmail.com>
References: <AANLkTik_4HRwUUYnFLR6BwevQi6W+FK2rNN7Kph+dAWk@mail.gmail.com>
 <AANLkTikda-CP42-_wnNtEpCJGc3kwNXvT0KgXjOOL+Bc@mail.gmail.com>
 <AANLkTimZnnjBMYUDM1pACYv8fHtu0xe-F_C0RJ8_ay_o@mail.gmail.com> <AANLkTimEMtt1JJerTzG4-X_Ez83MxtU_52wVQ_xJC8N3@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Sun, 21 Nov 2010 09:05:36 +1000
Message-ID: <AANLkTimJtXrhubvXUWSEsFy=knAs6CZDwTBA4d9xo8+E@mail.gmail.com>
Subject: Re: Unloading ath5k fails
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 12:18 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Nov 17, 2010 at 8:01 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>>> Hmm.. I just ran some tests myself on wireless-testing, with ath5k
>>> connected and not connected and didn't have any problems.  Are you
>>> doing anything special when bringing up the interface?  Can you
>>> post your kernel config?
>>
>> The interface is being set to IBSS. All that's been done is this:
>> iw reg set AU
>> iw dev wlan0 set type ibss
>> rmmod ath5k
>
> I don't know if you saw the other linux-wireless thread on this
> topic, but it seems related to ipv6 and not any particular driver,
> which explains why I didn't see it (I currently compile ipv6 out).

Ahhh I'm not going crazy! Thanks, I'll change the config and try again.

Cheers,

Jonathan

>
> --
> Bob Copeland %% www.bobcopeland.com
>
