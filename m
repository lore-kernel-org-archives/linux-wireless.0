Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab3KDQSU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 11:18:20 -0500
Message-ID: <1383581905.17589.0.camel@dcbw.foobar.com> (sfid-20131104_171824_159026_74469C96)
Subject: Re: orinoco (Lucent/Agere 9.48) unable to connect
From: Dan Williams <dcbw@redhat.com>
To: zaphod@berentweb.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Nov 2013 10:18:25 -0600
In-Reply-To: <CAPSTskvByfGWTyDmq9WeX7Em1N0DAAZ3eKDV5eV6qfkH2gDzdA@mail.gmail.com>
References: <CAPSTskvByfGWTyDmq9WeX7Em1N0DAAZ3eKDV5eV6qfkH2gDzdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-11-04 at 12:53 +0200, Beeblebrox wrote:
> I have an old laptop that has Wifi card as stated in subject. The card
> can scan and show SSID's, but cannot connect in any circumstances,
> including open/unencrypted broadcast.
> System: i386-pIII, running ubuntu 13.04 (driver ver: 3.8.0-32-generic
> Dmesg lines for orinoco:
> Fİrmware determined as Lucent/Agere  6.14
> Fİrmware determined as Lucent/Agere  9.48
> Wep supported, 104-bit key,  WPA-PSK supported
> 
> The log files don't give much info as to the connection error. What
> method can I use to get full debug from the connection process, in
> order to determine the origin of the problem (hardware, driver, etc)

What kind of access point are you trying to connect to?  These devices
only support 802.11b, so if the access point is newer and is using
802.11n, there are some 11n configurations that simply don't support
connections from 11b clients.

Dan

