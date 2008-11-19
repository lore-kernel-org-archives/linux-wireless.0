Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:28504 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYKSPh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 10:37:29 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2937ugf.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 07:37:27 -0800 (PST)
Message-ID: <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com> (sfid-20081119_163733_464931_B9660D6E)
Date: Wed, 19 Nov 2008 16:37:27 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
In-Reply-To: <1227095773.26243.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 <1227095773.26243.22.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> http://wireless.kernel.org/en/users/Documentation/modes#AccessPoint.28AP.29infrastructuremode
> johannes

Thank you, that's it, took the latest hostapd from git.
I can now connect from my iPod to the XG-603 in AP mode (unencrypted
and WPA/TKIP, WPA2/TKIP, WPA2/CCMP tested).
However - data throughput seems low; accessing a webserver I get an
update "now and then". I'm aware this can have a lots of causes - I
have more time and more cards available (XG-601/ISL3880, and an
AR5212/5213 one) and will play with this.

Stefan.
