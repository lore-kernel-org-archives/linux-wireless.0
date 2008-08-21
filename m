Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.225]:59915 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501AbYHUXGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 19:06:04 -0400
Received: by qb-out-0506.google.com with SMTP id a16so262915qbd.17
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 16:06:03 -0700 (PDT)
Message-ID: <48ADF4CF.9090400@gmail.com> (sfid-20080822_010609_901284_5541FF47)
Date: Fri, 22 Aug 2008 00:05:51 +0100
MIME-Version: 1.0
To: David.Woodhouse@intel.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/19] orinoco: WPA for Agere based cards
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
In-Reply-To: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 Aug, kilroyd@googlemail.com wrote:
> This patch series enables WPA on Agere based orinoco devices.
 <snip>=20
> To use WPA, you will need an Agere firmware image. You can get the
> necessary file at
> <http://marc.info/?l=3Dorinoco-devel&m=3D121078835610877>, just extra=
ct
> and rename orinoco.fw to agere_sta_fw.bin and place it in
> /lib/firmware (or distro equivalent). Alternatively you can try
> extract firmware from a Windows driver using the program in
> <http://marc.info/?l=3Dorinoco-devel&m=3D120846933719051>.

Hi,

The quoted patchset introduces the capability to load firmware for
a particular variant of the orinoco wireless cards. At the moment
the firmware image is only readily available in an email archive.

Can we include this firmware in the linux-firmware tree? If so
what do I need to do to get it there?

The firmware in the above link was originally distributed by Agere
within a driver with a BSD-style license. The only modification
I've made is to add a header defining offsets into the main image.
The original driver can still be found at
<http://www.xs4all.nl/~pptp/agere/wl_lkm_718_release.tar.gz>. I've
included the text of the license below.


Thanks,

Dave Kilroy.
---
License extracted from hcf/hcf.c

 * SOFTWARE LICENSE
 *
 * This software is provided subject to the following terms and conditi=
ons,
 * which you should read carefully before using the software.  Using th=
is
 * software indicates your acceptance of these terms and conditions.  I=
f you do
 * not agree with these terms and conditions, do not use the software.
 *
 * COPYRIGHT =A9 1994 - 1995  by AT&T.                All Rights Reserv=
ed
 * COPYRIGHT =A9 1996 - 2000 by Lucent Technologies.  All Rights Reserv=
ed
 * COPYRIGHT =A9 2001 - 2004  by Agere Systems Inc.   All Rights Reserv=
ed
 * All rights reserved.
 *
 * Redistribution and use in source or binary forms, with or without
 * modifications, are permitted provided that the following conditions =
are met:
 *
 * . Redistributions of source code must retain the above copyright not=
ice, this
 *    list of conditions and the following Disclaimer as comments in th=
e code as
 *    well as in the documentation and/or other materials provided with=
 the
 *    distribution.
 *
 * . Redistributions in binary form must reproduce the above copyright =
notice,
 *    this list of conditions and the following Disclaimer in the docum=
entation
 *    and/or other materials provided with the distribution.
 *
 * . Neither the name of Agere Systems Inc. nor the names of the contri=
butors
 *    may be used to endorse or promote products derived from this soft=
ware
 *    without specific prior written permission.
 *
 * Disclaimer
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANT=
IES,
 * INCLUDING, BUT NOT LIMITED TO, INFRINGEMENT AND THE IMPLIED WARRANTI=
ES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.=
  ANY
 * USE, MODIFICATION OR DISTRIBUTION OF THIS SOFTWARE IS SOLELY AT THE =
USERS OWN
 * RISK. IN NO EVENT SHALL AGERE SYSTEMS INC. OR CONTRIBUTORS BE LIABLE=
 FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL D=
AMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR S=
ERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAU=
SED AND
 * ON ANY THEORY OF LIABILITY, INCLUDING, BUT NOT LIMITED TO, CONTRACT,=
 STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN AN=
Y WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF S=
UCH
 * DAMAGE.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
