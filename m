Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60728 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2DROjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:39:23 -0400
Received: by bkcik5 with SMTP id ik5so5538171bkc.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 07:39:22 -0700 (PDT)
Subject: Re: wlan0 not present
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Dominik Feser <dominik.feser@googlemail.com>
In-Reply-To: <CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com>
Date: Wed, 18 Apr 2012 16:39:18 +0200
Cc: Dominik Feser <dominik.feser@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Message-Id: <FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com> (sfid-20120418_163927_379834_9954C930)
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <4F8DC25E.9090702@broadcom.com> <B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com> <4F8E0CBE.6010103@sipsolutions.net> <0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com> <CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com> <4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com> <CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There it is:

# lspci -x -s 02:00
02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
00: 86 80 82 00 02 00 10 00 34 00 80 02 10 00 00 00
10: 04 00 d0 e2 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 21 13
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00

Am 18.04.2012 um 11:30 schrieb Emmanuel Grumbach:

> On Wed, Apr 18, 2012 at 11:48, Dominik Feser
> <dominik.feser@googlemail.com> wrote:
>> Hi Emmanuel,
>> 
>> here is the output:
>> # lspci -s 02:00 -n
>> 02:00.0 0280: 8086:0082 (rev 34)
>> 
>> THX,
>> Dominik
>> 
> 
> Ouch I also need the subdeviceid:
> 
> sudo lspci -x -s 02:00 ?

