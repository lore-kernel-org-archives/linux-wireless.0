Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:46861 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZDXTSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 15:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <20090422140107.GD3288@tuxdriver.com>
References: <c4e36d110904220333u37304c79k6ab528f92b5f3718@mail.gmail.com>
	 <20090422140107.GD3288@tuxdriver.com>
Date: Fri, 24 Apr 2009 21:18:09 +0200
Message-ID: <c4e36d110904241218x209a4b76kf271f7288f1a33da@mail.gmail.com> (sfid-20090424_211821_497772_0C4E7A46)
Subject: Re: regression IWl3945 - doesn't work with recent 2.6.30-rcX
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/22 John W. Linville <linville@tuxdriver.com>:
> On Wed, Apr 22, 2009 at 12:33:03PM +0200, Zdenek Kabelac wrote:
>> Hi
>>
>> I'm checking whether -rcX kernel could be usable on my
>> T61/4GB/C2D/x86_64 - but wireless seems to be still out of
>> functionality:
>> I'm getting lots of weird trace-back messages and it looks like
>> iwl3945 is not working at all.
>> (attached messages from fresh build of -rc3 - but it never worked ev=
en in -rc1)
>
> Looks like this one did _not_ make -rc3:
>
> commit df833b1d73680f9f9dc72cbc3215edbbc6ab740d
> Author: Reinette Chatre <reinette.chatre@intel.com>
> Date: =A0 Tue Apr 21 10:55:48 2009 -0700
>
> =A0 =A0iwlwifi: DMA fixes
>
> =A0 =A0A few issues wrt DMA were uncovered when using the driver with=
 swiotlb.
> ...
>
> It is in wireless-2.6 and should be in net-2.6 -- please try one of t=
hose kernels.


I can confirm that current upstream linux commit
9f5a691253924fd033a58c6b1fed57bb0a4eccf4 works again with iwlwifi.
and it already contains the patch you suggested to check.

Zdenek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
