Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:50195 "EHLO
	webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbcHOVsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 17:48:41 -0400
To: Mike Mu <mikemu@google.com>, linux-wireless@vger.kernel.org
References: <CAGTDyhHOxwTiXtsWuy1cLq+eraikTs9McS0kUBXS2W6B09CwgQ@mail.gmail.com>
Cc: Stanley Mui <stanleymui@google.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <f32852ed-0fee-1711-e26d-5a41f831267a@dd-wrt.com> (sfid-20160815_234844_769414_DA3F6382)
Date: Mon, 15 Aug 2016 23:48:35 +0200
MIME-Version: 1.0
In-Reply-To: <CAGTDyhHOxwTiXtsWuy1cLq+eraikTs9McS0kUBXS2W6B09CwgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: Configuring Minstrel-Blues
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.08.2016 um 23:41 schrieb Mike Mu:
> Hi Linux-Wireless,
>
> I am trying to enable Minstrel-Blues for the ath9k chipset that's used
> in Google Fiber's access points. I applied the patches in
> https://github.com/thuehn/Minstrel-Blues/tree/master/src onto our
> backports-20160122 tree, with some unsuspicious merge conflicts, and
> built an image.
>
> To test, I ran iperf from the AP to a station very close by. I
> captured the packets to look at the RSSI with and without the
> Minstrel-Blues patches applied, but did not see any difference in
> RSSI.
why do you think that a rate control algorithm will change the rssi?
> Is there anything I need to configure first to make it work? Is it
> possible that I'm missing a patch that's not in backports-20160122?
>
> Thanks!
> Mike
>


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
