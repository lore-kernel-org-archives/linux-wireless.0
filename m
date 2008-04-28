Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:54406 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765388AbYD1KHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 06:07:52 -0400
Received: by fg-out-1718.google.com with SMTP id l27so4882878fgb.17
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2008 03:07:50 -0700 (PDT)
Message-ID: <544ab8580804280307u74d8240blfb5689f6dbf18b1@mail.gmail.com> (sfid-20080428_120759_923691_3A623BF9)
Date: Mon, 28 Apr 2008 12:07:49 +0200
From: "=?ISO-8859-1?Q?K=E1roly_Kasza?=" <kaszak@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: w35und: one more unneccessary function
Cc: "Pavel Machek" <pavel@ucw.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	someone@dunanet.hu
In-Reply-To: <43e72e890804271433j9f81c22p249a2eb239d07d08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080419194206.GA17558@elf.ucw.cz>
	 <43e72e890804252208g2d19acedh1ceff3aa209489ad@mail.gmail.com>
	 <20080427181336.GB493@elf.ucw.cz>
	 <43e72e890804271433j9f81c22p249a2eb239d07d08@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  >  > drivers/net/wireless/winbond/ ? What tree is this in?
>  >
>  >  My tree :-). It should be in some branch at code.google, too, and I
>  >  can do a full diff against vanilla if there's interest.
>
>  Cool :) You seem to have quite a few trees. Which tree is it on? What
>  is the winbond driver? I guess I also don't understand the diffs
>  against your own tree on this list if we don't have much info for this
>  winbond driver or if its not merged yet. Is there a project link where
>  we can read a bit more about this driver and hardware it supports?

Hi,

Pavel's tree can be mostly checked out from
http://winbondport.googlecode.com/svn/branches/pavel , however it may
be incomplete, because I can't always correctly apply the patches he
sends against the previous ones... It is based on an old and lousy
written driver (which works, but written in WEXT), and getting to work
in softmac. The old driver can be found at the above svn too, rev 2.

The chip is the W89C35 (IS89C35) USB2WLAN adapter found in many UMPCs
(koshinja, vye, packard bell) and other integrated stuff. Both of us
got an Airoha 2230 RF chip with it. The eeprom should be 93cx6
compatible, but I'm not sure.

Some of us are trying to write a whole new driver fully dropping the
old one in softmac too. Anyways, at least soon this device should be
supported in vanilla too.

KK
