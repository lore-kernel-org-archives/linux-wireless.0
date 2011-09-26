Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33969 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab1IZS0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 14:26:14 -0400
Received: by eya28 with SMTP id 28so3853548eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 11:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C5A7FB31FD9AEA42B600BDC3C74F8E0017052223@orsmsx511.amr.corp.intel.com>
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
Date: Mon, 26 Sep 2011 20:26:12 +0200
Message-ID: <CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com> (sfid-20110926_202617_549453_059F1961)
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
From: Henrik Friedrichsen <hrkfdn@gmail.com>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Meenakshi

On Mon, Sep 26, 2011 at 7:58 PM, Venkataraman, Meenakshi
<meenakshi.venkataraman@intel.com> wrote:
> [MV] Just to verify that this is a 11n issue, you said you tried disabling the 11n mode?
Yes. I just did, once again, to verify it. No change, unfortunately :(

> Also, in your first email you mentioned that you were using 3.0.4 earlier? What were the results in that version?
It was the same. I was hoping a newer kernel might contain a fix of
some sort, that's why I updated it.

> I wonder if we're somehow using very low rates. Can you please send debug logs from your experiment with debug flags 0x143fff?
Here are the logs: http://diff.cc/tmp/kernel_iwlagn_3.log.bz2
They were made with "11n_disable=1" and without the patches posted by Wey-Yi.

Cheers,
Henrik
