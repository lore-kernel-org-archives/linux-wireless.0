Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60047 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0JNSTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 14:19:22 -0400
Received: by gxk6 with SMTP id 6so1639927gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 11:19:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101014181446.GC2427@tuxdriver.com>
References: <AANLkTinQMRGkOvi4e4JMsHGV_BF_4Rf5oHCtZgQjwQ1g@mail.gmail.com>
 <20101014165111.GA22130@suse.de> <AANLkTin9PxzROyCQxiT5-ca4CUQK+kppS7gAibbbZ2=v@mail.gmail.com>
 <20101014171739.GA28522@suse.de> <AANLkTimz7xKtz15tVyytxgJ3mQJUNk-=ja-4cJBWJUV8@mail.gmail.com>
 <20101014181446.GC2427@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 Oct 2010 11:18:59 -0700
Message-ID: <AANLkTinf_uZMhYk-AVBRyprOp=AW0GEkqVEzfYsiFmXa@mail.gmail.com>
Subject: Re: Licensing wlc_phy_radio.h and brcm80211 (was: [PATCH 3/3] b43:
 N-PHY: add 2055 radio regs)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Greg KH <gregkh@suse.de>,
	=?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 11:14 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Oct 14, 2010 at 07:38:49PM +0200, Rafał Miłecki wrote:
>> 2010/10/14 Greg KH <gregkh@suse.de>:
>
>> > I don't think that bitfields are copyrightable :)
>>
>> What about rest of the code? brcm80211 seems to support even newer
>> devices we don't even try to support in b43 yet.
>>
>> Can I treat code as pure-GPL and do not care about that
>> maybe-not-GPL-compatible statement in header?
>
> IANAL, but I think you should include the copyright statment with a
> comment like "some portions covered by the following" at the top of
> the files including such code.  Beyond that, I think you are fine
> including it under GPL terms (which are merely more restrictive,
> neither less restrictive nor incompatible).

Agreed, for an example of where this was done check the ar9170 driver,
Johannes took ISC licensed code from Otus and GPL'd it. You really can
only GPL the code if you are making copyrightable changes to it though
so best is if you leave the header as-is with the existing license
unless you are making tons of changes. For further details you can
refer to these guidelines:

http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html

  Luis
