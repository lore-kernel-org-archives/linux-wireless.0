Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1IZVc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 17:32:57 -0400
Received: by eya28 with SMTP id 28so4022123eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 14:32:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C5A7FB31FD9AEA42B600BDC3C74F8E00170525B4@orsmsx511.amr.corp.intel.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	<CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	<1317048872.2400.4.camel@wwguy-ubuntu>
	<CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
	<1317049160.1958.8.camel@wwguy-huron>
	<CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
	<CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
	<1317050380.1958.13.camel@wwguy-huron>
	<CAJTrwG46qRYvda1vcCZXv0BTUyf26gx2qgpNgOG-bm-BCMpqfg@mail.gmail.com>
	<1317053131.1958.15.camel@wwguy-huron>
	<C5A7FB31FD9AEA42B600BDC3C74F8E0017052223@orsmsx511.amr.corp.intel.com>
	<CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com>
	<1317062004.1958.18.camel@wwguy-huron>
	<CAJTrwG57r-B-eT-FODsDW1UgoVcS68zcUWo1mOrdHRdoXtNmCg@mail.gmail.com>
	<C5A7FB31FD9AEA42B600BDC3C74F8E001705253B@orsmsx511.amr.corp.intel.com>
	<CAJTrwG5MXfixhnNPOdoA3-DYEeKpC==uv4WvE78ZE5U+A10T7Q@mail.gmail.com>
	<C5A7FB31FD9AEA42B600BDC3C74F8E0017052566@orsmsx511.amr.corp.intel.com>
	<CAJTrwG4AHo-_P_j8x2_vbd-eCXRVM=MPRoCh-uQQPHoKduyxvw@mail.gmail.com>
	<C5A7FB31FD9AEA42B600BDC3C74F8E00170525B4@orsmsx511.amr.corp.intel.com>
Date: Mon, 26 Sep 2011 23:32:55 +0200
Message-ID: <CAJTrwG42nO9vdRAaka32Fj6X27cSfnsOOq7GCg0G2d11tTTryQ@mail.gmail.com> (sfid-20110926_233300_327108_76765BEF)
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
From: Henrik Friedrichsen <hrkfdn@gmail.com>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 11:24 PM, Venkataraman, Meenakshi
<meenakshi.venkataraman@intel.com> wrote:
> [MV] Well...what I'm interested in is really the IEEE802.11 packets for when you attempt to browse the web (or other workloads) where you're seeing the issue. Of course, TCP traffic that these packets are carrying will also be helpful.

I see. You're going to have to excuse me here, though. I have never
done WiFi debugging. What would be the easiest (and for you most
useful) way to capture IEEE802.11 packets?
