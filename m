Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65120 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1IZQDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 12:03:24 -0400
Received: by eya28 with SMTP id 28so3727622eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 09:03:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	<CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com>
	<1317048872.2400.4.camel@wwguy-ubuntu>
	<CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
	<1317049160.1958.8.camel@wwguy-huron>
	<CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
Date: Mon, 26 Sep 2011 18:03:22 +0200
Message-ID: <CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com> (sfid-20110926_180336_474631_DEEA84DA)
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
From: Henrik Friedrichsen <hrkfdn@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 4:59 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> few things I will suggest and please give a try:
> 1. Please try to apply the following two patches I attach here.
> 2. load the iwlagn with debug=0x45800006, the log will be big, but it
> will contain more information on the tx/rx path.

Here's the log you asked for:
http://diff.cc/tmp/kernel_iwlagn_2.log.bz2

As I said, this problem does not occur with the Windows driver. You
said you are actively working on it. Does that mean, the problem is
known to you?

Cheers,
Henrik
