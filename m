Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:57545 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0BVSOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 13:14:40 -0500
Received: by pxi14 with SMTP id 14so1469284pxi.15
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2010 10:14:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B828048.7020303@googlemail.com>
References: <4B828048.7020303@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Feb 2010 10:14:20 -0800
Message-ID: <43e72e891002221014g7a513d9dybf868519ea54d86f@mail.gmail.com>
Subject: Re: Main documentation on ath9k+802.11n
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2010 at 5:02 AM, Dennis Borgmann
<dennis.borgmann@googlemail.com> wrote:
> Hi linux-wireless list,
> hi hostap list!
>
> I am trying to get a 802.11n-network as test running. I want to test the
> highest throughput, that I can do with this setup to see, what could be
> possible for me.
>
> My setup is a Senao EMP-7605 card and ath9k with a 2.6.32.8-kernel.
> Thanks to Jouni Malinen, I am now using the latest snapshot of
> hostapd-0.6.10. If I start hostapd, my Lenovo Thinkpad(I think, there is
> an Intel card running inside there) can find the network, that I
> established with ath9k, but another Senao EMP-7905 with the same setup
> as mentioned above won't find the wireless network at all, even during a
> scan. If I do an iperf between the Lenovo and the board, that runs the
> AP with hostapd, I get throughput rates of about 6 Mbit/s. iwconfig on
> the Lenovo shows the bitrate set to "0" - meaning auto.
>
> I cannot find valuable documentation about setting up a wireless-link
> with ath9k using 802.11n-capabilities. Is there any hint, that someone
> could give me or a webpage that I could be pointed to? I just want to do
> some speed-tests, but even the "ht_kapab"-field of hostapd leaves me
> without any knowledge, what to put in there...
>
> Any help would be appreciated!

Documentation is not supposed to be device specific, so for hostapd
with 802.11n we currently have:

http://wireless.kernel.org/en/users/Documentation/hostapd

 Luis
