Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27674 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab1IZO77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 10:59:59 -0400
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM
 Fritz!Box (7390)" incompatible
From: wwguy <wey-yi.w.guy@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	 <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 07:54:32 -0700
Message-ID: <1317048872.2400.4.camel@wwguy-ubuntu> (sfid-20110926_170002_405914_2A853B3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrik,

On Mon, 2011-09-26 at 07:07 -0700, Henrik Friedrichsen wrote:
> One more thing I have noticed:
> 
> This message is only being printed when I connect to the AP, that I
> have problems with:
> 
> Sep 26 07:05:03 dharma kernel: [ 2213.379252] iwlagn 0000:03:00.0: Tx
> aggregation enabled on ra = xx:xx:xx:xx:xx:xx tid = 0
> 
this message telling us "11n/aggregation" is started; so looks like the
problem is aggregation related.

> On the APs that work fine, it DOES NOT get printed.

I don't see anything special in the dmesg log you send, could you
provide us more information?

1. AP brand and model
2. channel band and number
3. firmware version
4. system setup (bluetooth or any other wireless devices on the system?)
5. if you can provide us more detail log, it will be great. (loading the
iwlagn with debug=0x43fff)


Thanks
Wey
> T

