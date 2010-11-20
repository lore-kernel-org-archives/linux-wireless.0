Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37616 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0KTOS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 09:18:57 -0500
Received: by qyk33 with SMTP id 33so3828qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 06:18:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimZnnjBMYUDM1pACYv8fHtu0xe-F_C0RJ8_ay_o@mail.gmail.com>
References: <AANLkTik_4HRwUUYnFLR6BwevQi6W+FK2rNN7Kph+dAWk@mail.gmail.com>
	<AANLkTikda-CP42-_wnNtEpCJGc3kwNXvT0KgXjOOL+Bc@mail.gmail.com>
	<AANLkTimZnnjBMYUDM1pACYv8fHtu0xe-F_C0RJ8_ay_o@mail.gmail.com>
Date: Sat, 20 Nov 2010 09:18:54 -0500
Message-ID: <AANLkTimEMtt1JJerTzG4-X_Ez83MxtU_52wVQ_xJC8N3@mail.gmail.com>
Subject: Re: Unloading ath5k fails
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 8:01 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>> Hmm.. I just ran some tests myself on wireless-testing, with ath5k
>> connected and not connected and didn't have any problems.  Are you
>> doing anything special when bringing up the interface?  Can you
>> post your kernel config?
>
> The interface is being set to IBSS. All that's been done is this:
> iw reg set AU
> iw dev wlan0 set type ibss
> rmmod ath5k

I don't know if you saw the other linux-wireless thread on this
topic, but it seems related to ipv6 and not any particular driver,
which explains why I didn't see it (I currently compile ipv6 out).

-- 
Bob Copeland %% www.bobcopeland.com
