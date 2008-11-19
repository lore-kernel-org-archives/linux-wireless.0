Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:61881 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYKSQXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 11:23:45 -0500
Received: by ik-out-1112.google.com with SMTP id c29so25591ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 08:23:44 -0800 (PST)
Message-ID: <f76a32050811190823r51033a4dqa29de6d1e6663388@mail.gmail.com> (sfid-20081119_172352_217619_ED1C4063)
Date: Wed, 19 Nov 2008 17:23:44 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227109286.26243.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 <1227095773.26243.22.camel@johannes.berg>
	 <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com>
	 <1227109286.26243.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> However - data throughput seems low; accessing a webserver I get an
>> update "now and then". I'm aware this can have a lots of causes - I
>> have more time and more cards available (XG-601/ISL3880, and an
>> AR5212/5213 one) and will play with this.
>
> What rate control algorithm did you compile into the kernel? Minstrel
> should perform quite well on p54, unless we made a mistake.

I had only compiled in the PID-based thing. Fixed that, made Minstrel
the default.

At first glance this improves things, but not enough. I have an ajax
application that is polling the web server and which runs into its 5
sec timeouts fairly regularly. I had this working almost ok before
with an Atheros card and the latest madwifi driver, but got trashed by
"stuck beacon" events. I will try this card again with the ath5k
driver and see how this works.

Thanks for your help,
  Stefan.
