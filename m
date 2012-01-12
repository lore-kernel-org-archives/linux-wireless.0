Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50101 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2ALVjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 16:39:20 -0500
Received: by iabz25 with SMTP id z25so3293403iab.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 13:39:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0F3E77.1040208@broadcom.com>
References: <CAC9WiBj8VkYe7ku7rc-e_+d7yNEAtEiozs8tnR_A1T1H3XjiSA@mail.gmail.com>
	<4F0F3E77.1040208@broadcom.com>
Date: Thu, 12 Jan 2012 22:39:20 +0100
Message-ID: <CAC9WiBgYYhs9WyWcojg67PHev+Bz8=Eq3VrLfr_BgWK8=g9D_w@mail.gmail.com> (sfid-20120112_223935_288577_7623D521)
Subject: Re: brcmsmac broken with 3.2
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Alwin Beukers <alwin@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2012 at 9:11 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/12/2012 08:32 PM, Francis Moreau wrote:
>> Hello,
>>
>> I'm facing a new issue after upgrading from 3.1 to 3.2.
>>
>> It happens when switching on/off my wireless card (BCM4313 [14e4:4727]).
>>
>> Here's the oops I'm getting:
>>
>> [36370.370768] WARNING: at net/mac80211/rx.c:2979
>> ieee80211_rx+0x91b/0x9e0 [mac80211]()
>
> What kernel tree are you using?

Mainline but I added one patch which allows me to use the bcrmsmac
driver while bcma is enabled.

-- 
Francis
