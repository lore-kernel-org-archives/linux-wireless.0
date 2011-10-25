Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.schottelius.org ([77.109.138.221]:48685 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1JYGlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 02:41:53 -0400
Date: Tue, 25 Oct 2011 08:41:40 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111025064140.GB20334@schottelius.org> (sfid-20111025_084157_385471_AA9D0B3E)
References: <4E9EE20F.1030403@broadcom.com>
 <20111019145501.GB1414@schottelius.org>
 <4E9EFF51.6000104@broadcom.com>
 <20111019214250.GC2432@schottelius.org>
 <4E9FBFA7.4040502@broadcom.com>
 <20111022015945.GC26186@ethz.ch>
 <4EA3E6AD.4030701@broadcom.com>
 <20111023105305.GA2489@schottelius.org>
 <20111023194823.GB2489@schottelius.org>
 <4EA55F13.5020300@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EA55F13.5020300@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Arend,

Arend van Spriel [Mon, Oct 24, 2011 at 02:50:27PM +0200]:
> On 10/23/2011 09:48 PM, Nico Schottelius wrote:
> I tried to make sense of the dmesg log you sent me. Not sure what is
> happening so could do the following:
> 
> 1. Determine wpa_supplicant version using -v option.

wpa_supplicant v0.7.3

> 2. Add '-ddt' option in DBus service file:
> 	wpa_supplicant >= 0.7: fi.w1.wpa_supplicant1.service
> 	wpa_supplicant < 0.7:  fi.epitest.hostap.WPASupplicant.service
>    (located in /usr/share/dbus-1/system-services/).
> 3. Reproduce the problem and sent /var/log/syslog.

I'll have to postpone these two, because I've to exchange the physical
device, as the vendor supplied the wrong version (i5 instead of i7).

As soon as I've the i7 version setup, I'll reply to this mail!

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
