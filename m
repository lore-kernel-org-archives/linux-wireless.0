Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61367 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2HBXZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 19:25:47 -0400
Received: by weyx8 with SMTP id x8so50852wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 16:25:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1corc7rp_MRrV=MuDRXqqibmxL9MXwhE=zrkNSNfWqzg@mail.gmail.com>
References: <5016F03F.1020508@t-online.de>
	<5016F59E.9070101@01019freenet.de>
	<CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com>
	<5019EC7D.5030208@01019freenet.de>
	<CANUX_P10yfdy+d9txsp1RV9niKex_5WAr0VFsjsMiPosv6M+mA@mail.gmail.com>
	<20120802165429.29839020@dualc.maya.org>
	<CANUX_P1corc7rp_MRrV=MuDRXqqibmxL9MXwhE=zrkNSNfWqzg@mail.gmail.com>
Date: Fri, 3 Aug 2012 02:25:45 +0300
Message-ID: <CANUX_P2++es_wmiPm=k_ApKB5+4xtkZKeAu07xR3j0SSPmLOfA@mail.gmail.com> (sfid-20120803_012551_298262_0881C765)
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 2, 2012 at 9:42 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>>
>>>> He wrote, too, that the installation of compat-wireless
>>>> (unfortunately, he didn't told me which version), didn't changed the
>>>> situation.
>>>>
>>>> I attached for him the output of
>>>> options iwlwifi debug=0xffffffff
>>>>
>>>> The last part of it:
>>>
>>> what about the logs *before* that?
>>
>> What are you missing? The attachment contains of 1739 lines. It seems to
>> be the complete output from dmesg from 0 to 675 seconds!
>>
> Sorry - I missed the attached file. Ok so you are using the latest fw
> and you get a FW in INIT stage.
> Please file a bug.
> I thought it would be a quick and easy issue - but apparently it is not... Sorry

Can you try to switch the NIC cards between the 2 laptops (you told me
one is working the other one isn't)?
If you are afraid to void the warranty then it is probably not a good idea.

Did you try to install windows on the same machine?
