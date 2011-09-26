Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63861 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1IZQKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 12:10:11 -0400
Received: by eya28 with SMTP id 28so3734317eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 09:10:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317050380.1958.13.camel@wwguy-huron>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	<CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	<1317048872.2400.4.camel@wwguy-ubuntu>
	<CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
	<1317049160.1958.8.camel@wwguy-huron>
	<CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
	<CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
	<1317050380.1958.13.camel@wwguy-huron>
Date: Mon, 26 Sep 2011 18:10:10 +0200
Message-ID: <CAJTrwG46qRYvda1vcCZXv0BTUyf26gx2qgpNgOG-bm-BCMpqfg@mail.gmail.com> (sfid-20110926_181016_070411_A891ADB3)
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
From: Henrik Friedrichsen <hrkfdn@gmail.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see. I hope the log is useful to you. I'm not sure, but this issue
seems to be slightly different to your average performance issue. My
Android device needs 1 second to completely load the Router webpanel,
whereas my laptop with the Intel chip needs 30 seconds.

I'm afraid the patches did not make any difference. Oh btw, I did
apply them before making the log. I believe that was your intention.

On Mon, Sep 26, 2011 at 5:19 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> On Mon, 2011-09-26 at 09:03 -0700, Henrik Friedrichsen wrote:
>> On Mon, Sep 26, 2011 at 4:59 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>> > few things I will suggest and please give a try:
>> > 1. Please try to apply the following two patches I attach here.
>> > 2. load the iwlagn with debug=0x45800006, the log will be big, but it
>> > will contain more information on the tx/rx path.
>>
>> Here's the log you asked for:
>> http://diff.cc/tmp/kernel_iwlagn_2.log.bz2
>>
>> As I said, this problem does not occur with the Windows driver. You
>> said you are actively working on it. Does that mean, the problem is
>> known to you?
>>
>
> we are seeing performance issue and still can not root cause the
> problem. that is the reason I send you 2 patches for testing. We are
> very active working on fix the performance problem. the symptoms might
> be different, but we aware there were issues.
>
> Thx
> Wey
>
>
>
