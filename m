Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:41852 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaC1P7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 11:59:10 -0400
Received: by mail-bk0-f45.google.com with SMTP id na10so929107bkb.18
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 08:59:08 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Pekka =?ISO-8859-1?Q?Pietik=E4inen?= <pp@ee.oulu.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [linux-firmware] Bump carl9170 1.9.6 -> 1.9.9?
Date: Fri, 28 Mar 2014 14:18:17 +0100
Message-ID: <3136247.FK8ifUDRkI@debian64> (sfid-20140328_165926_420273_730AFA12)
In-Reply-To: <53342374.7010602@ee.oulu.fi>
References: <53342374.7010602@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 27, 2014 03:11:16 PM Pekka Pietikäinen wrote:
> linux-firmware seems to ship an oldish carl9170-1.fw, which seems to
> work ok except for spewing a lot of
> 
> "[1889329.659407] ieee80211 phy0: invalid plcp cck rate (0)." messages.
In case of carl9170, these messages indicate that some non-802.11 transmitter
is near by (and confusing the chip a bit). These messages (and the associated
issues) can magically appear and disappear... So, chances are that they reappear
sometime later. There's little the firmware can do here.

> Grabbing 1.9.9 seems to make them go away and the driver works just as
> well :-)
> 
> Any chance of someone bumping the version so the newer firmware gets
> shipped by distros?
Oh, I tried that back in October 2013.
<http://comments.gmane.org/gmane.linux.kernel.wireless.general/114639>

But no agreement has been reached. And 1.9.6 is good enough to download
the later firmware releases though. I'm sorry, but that's how it is at the moment.
But if you want to help, you could make a patch (the way Rick/Ben wants it) and
post it here (linux-wireless@vger.kernel.org). I can't do it, I tried and failed several
times. If you are interested: The firmware is under GPLv2, no sign-offs or acks
(from QCA, me or anyone else) is needed, you (or anyone else interested) can
go right ahead. 

Regards,

Christian
