Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f104.google.com ([209.85.221.104]:59778 "EHLO
	mail-qy0-f104.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZFCCXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 22:23:33 -0400
Received: by qyk2 with SMTP id 2so1486565qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 19:23:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ee8eb53d0906021917q787c160ja3b3a453f09da1d0@mail.gmail.com>
References: <ee8eb53d0905312008rbd346d8h171fedb96d2a3d96@mail.gmail.com>
	 <1243858809.5299.15.camel@johannes.local>
	 <20090601131742.GA3386@tuxdriver.com>
	 <ee8eb53d0906021917q787c160ja3b3a453f09da1d0@mail.gmail.com>
Date: Tue, 2 Jun 2009 23:23:34 -0300
Message-ID: <ee8eb53d0906021923k3dc3578er755c4b3676d6495@mail.gmail.com>
Subject: Re: [GSoC 2009] Automation of testing using mac80211_hwsim and Orbit
	- status report 01
From: Georgy Berdyshev <codingmaster@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

I was doing some additional tests and it seems that unloading the
mac80211_hwsim kernel module and reloading
it with the same configuration triggers the same error again.

Georgy

On Tue, Jun 2, 2009 at 11:17 PM, Georgy Berdyshev
<codingmaster@gmail.com> wrote:
> Hi,
>
> I had recompiled the kernel and tried to run hostapd again and now it
> is working.
> Still using the same settings. It seems that the problem has been
> solved with the latest git pull.
>
> That was the problem before (e.g. running the vlan example
> hostapd.conf within hostap/mac80211_hwsim/tests/0002-vlan)
> /opt/wifi/bin/hostapd hostapd.conf
> Configuration file: hostapd.conf
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.
> ELOOP: remaining socket: sock=3 eloop_data=0x977be10
> user_data=0x977bfa0 handler=0x8076200
>
> Thanks, Georgy
>
> --
> Georgy Berdyshev
>
> GPG key: 830F68C5
> Fingerprint: 0379 ED5A BEE5 65A8 7BD5  31E7 F5B4 1EC7 830F 68C5
>



-- 
Georgy Berdyshev

GPG key: 830F68C5
Fingerprint: 0379 ED5A BEE5 65A8 7BD5  31E7 F5B4 1EC7 830F 68C5
