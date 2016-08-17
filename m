Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.242]:49138 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbcHQL6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 07:58:19 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Configuring Minstrel-Blues
From: =?utf-8?Q?Thomas_H=C3=BChn?= <thomas@inet.tu-berlin.de>
In-Reply-To: <CAGTDyhHOxwTiXtsWuy1cLq+eraikTs9McS0kUBXS2W6B09CwgQ@mail.gmail.com>
Date: Wed, 17 Aug 2016 13:52:42 +0200
Cc: linux-wireless ??? <linux-wireless@vger.kernel.org>,
	Stanley Mui <stanleymui@google.com>
Message-Id: <B3898E11-6D02-4B21-B795-D7DF7CB6F576@inet.tu-berlin.de> (sfid-20160817_135822_317371_E50BE022)
References: <CAGTDyhHOxwTiXtsWuy1cLq+eraikTs9McS0kUBXS2W6B09CwgQ@mail.gmail.com>
To: Mike Mu <mikemu@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mike,

I am working on the Minstrel-Blues part to get it integrated into minstrel_ht. My working demo is with ath5k an legacy minstrel.
As soon as I have a testing patch, I am going to announce it here.

Greetings from Berlin
Thomas

> On 15 Aug 2016, at 23:41, Mike Mu <mikemu@google.com> wrote:
> 
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
> 
> Is there anything I need to configure first to make it work? Is it
> possible that I'm missing a patch that's not in backports-20160122?
> 
> Thanks!
> Mike
