Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54171 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0CSRml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 13:42:41 -0400
Received: by ywh36 with SMTP id 36so720278ywh.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 10:42:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1269018604.2446.1779.camel@rchatre-DESK>
References: <f39b508c1003170613g5a8754a2kc9e15075c16f499b@mail.gmail.com>
	 <1268978712.2446.1757.camel@rchatre-DESK>
	 <f39b508c1003190949m91f4070i4d8d19929f8d6787@mail.gmail.com>
	 <1269018604.2446.1779.camel@rchatre-DESK>
Date: Fri, 19 Mar 2010 12:42:39 -0500
Message-ID: <f39b508c1003191042v23587b50iea5217a877eb9423@mail.gmail.com>
Subject: Re: Re:
From: Vasil Lalov <vasil.lalov@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette,

Thanks a lot for directing me to the right place. I will open up a new
bugreport right away!
Have a good weekend!

Vasil
===
Vasil Lalov
Sr. Systems Administrator
Chicago Public Library


On Fri, Mar 19, 2010 at 12:10 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Fri, 2010-03-19 at 09:49 -0700, Vasil Lalov wrote:
>> Thanks for responding to this. I also noticed other things. It seems
>> that this Microcode SW error occurs because the wifi card is
>> overheating. When used in n-mode and there is a large file transfer,
>> the temperature of the card rises to over 62C. Soon after this, the
>> microcode error occurs and the card gets disassociated.
>>
>> Doing more research on the power vs temperature problem, I discovered
>> that other users are seeing this as well. Some have solved their
>> problem by enabling the power management for the wifi card by issuing
>
> I am not familiar with these workarounds. Could you please submit a new
> bug at http://bugzilla.intellinuxwireless.org/ or add your information
> to a bug in this system if you find one that is related?
>
> Reinette
>
>
>
>
