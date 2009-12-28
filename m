Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55964 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZL1UeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 15:34:14 -0500
Received: by fxm25 with SMTP id 25so4827456fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 28 Dec 2009 12:34:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261971942.6037.57.camel@debian>
References: <E9954878DD1FB34FAE5187FB88C58A357683393C@orsmsx506.amr.corp.intel.com>
	<1261363447.12157.624.camel@debian> <69e28c910912210552p1f63a47dw9fbabf2c26ce02e9@mail.gmail.com>
	<1261971942.6037.57.camel@debian>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 28 Dec 2009 21:33:52 +0100
Message-ID: <69e28c910912281233v220e9896t5686111030d5f30@mail.gmail.com>
Subject: Re: Intel 4965 HT rates
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Valentin Manea <linux-wireless@mrs.ro>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/12/28 Zhu Yi <yi.zhu@intel.com>:
> On Mon, 2009-12-21 at 21:52 +0800, Gábor Stefanik wrote:
>> On Mon, Dec 21, 2009 at 3:44 AM, Zhu Yi <yi.zhu@intel.com> wrote:
>> > On Mon, 2009-12-21 at 10:33 +0800, Guy, Wey-Yi W wrote:
>> >> For 4965, 40MHz only supported in g band
>> >
>> > We don't support 40MHz channels in 2.4G band. See comments in
>> > iwl-eeprom.h:
>> >
>> >  *
>> >  * NOTE:  4965 does not support HT40 channels on 2.4 GHz.
>> >  */
>> >
>> > Thanks,
>> > -yi
>>
>> But why does the Windows driver for 4965 support it then?
>
> Have you tested how well it is supported? The firmware people suggest to
> disable this feature (although the hardware was originally designed to)
> due to some internal problems.
>
> Thanks,
> -yi
>
>

Doesn't the Windows driver use a completely different, thinner
firmware (without all the regulatory hardening crap, as the driver
itself is closed-source)?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
