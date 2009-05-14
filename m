Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:37110 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZENRns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 13:43:48 -0400
Received: by bwz22 with SMTP id 22so1443878bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 10:43:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242322940.32358.31.camel@rc-desk>
References: <1242321566.32358.19.camel@rc-desk>
	 <b170af450905141022q29f7a8cfl1c079e473f575c49@mail.gmail.com>
	 <1242322940.32358.31.camel@rc-desk>
Date: Thu, 14 May 2009 19:43:48 +0200
Message-ID: <b170af450905141043r50c4831eh73999eef98bea7bf@mail.gmail.com>
Subject: Re: [ipw3945-devel] iwlwifi 5150 uCode available
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 maja 2009 19:42 użytkownik reinette chatre
<reinette.chatre@intel.com> napisał:
> Hi,
>
> On Thu, 2009-05-14 at 10:22 -0700, Rafał Miłecki wrote:
>> 2009/5/14 reinette chatre <reinette.chatre@intel.com>:
>> > uCode for Intel Wireless WiFi Link 5150AGN is now available for download
>> > from http://intellinuxwireless.org/?n=Downloads
>>
>> Changelog is top secret as usually? ;)
>
> Nope ... this is the very first release of this uCode for this
> particular hardware. A changelog does not make sense in this case.
>
>
>> Should this fix
>> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1946 (wrong
>> command queue)?
>
>
> This bug is against 5100/5300 hardware, so this uCode is not what you
> are looking for. We are working on getting uCode for 5100/5300 hardware
> (that includes a fix for this bug) out the door.
>
> Reinette

Ah, I gone wrong with that numbers understanding. Maybe putting
supported hardware in ucode's README would be a good idea? :)
Currently visiting http://intellinuxwireless.org/?n=Downloads doesn't
provide much help about choosing right firmware for 5100/5300(/5200?).
Or at last some short info on download page?

-- 
Rafał Miłecki
