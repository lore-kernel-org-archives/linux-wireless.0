Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35397 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab3AYI7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 03:59:07 -0500
Received: by mail-vc0-f182.google.com with SMTP id fl17so89189vcb.41
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 00:59:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d-_=PcT2nZq=TToSVXroMR0HOy+pbAoeMP7nxaYzKopYQ@mail.gmail.com>
References: <20130124205931.GB16252@localhost.localdomain>
	<EDAA1034-ABF9-4CC2-9055-2340462443AE@gmail.com>
	<CAGXE3d-_=PcT2nZq=TToSVXroMR0HOy+pbAoeMP7nxaYzKopYQ@mail.gmail.com>
Date: Fri, 25 Jan 2013 09:51:46 +0100
Message-ID: <CAL1gcdPoTSHWgDBf2BkAXXeJV6Whj1pXqGQ8=GoPxrNBnXRpVw@mail.gmail.com> (sfid-20130125_095911_244497_57188573)
Subject: Re: [PATCH 1/4] rt2x00: print warning, notice and info as default
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 9:46 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Thu, Jan 24, 2013 at 10:06 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> On 24 jan. 2013, at 21:59, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>>
>>> Some messages provide useful information, but are disabled without
>>> CONFIG_RT2X00_DEBUG=y, so enable them by default
>>>
>>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>>
>> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>
>> Thanks for respinning.
>
> Fine with me, however, in the future we could think of just using
> dynamic debug in rt2x00 (pr_debug etc). Would allow a user to
> enable debug output selectively during runtime.
>

I was thinking about the same and I have put the conversion to dynamic
debug on my TODO list
(unless someone beats me to it, I will look at this during the weekend).

---
Gertjan
