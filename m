Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56700 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2A3XkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 18:40:05 -0500
Received: by ghrr11 with SMTP id r11so2079720ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 15:40:04 -0800 (PST)
Message-ID: <4F272A51.2050508@lwfinger.net> (sfid-20120131_004010_013598_11C400FA)
Date: Mon, 30 Jan 2012 17:40:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Subject: Re: rtl8187 behavior change/breakage with 3.2.1-3.fc16.x86_64<->3.2.2-1.fc16.x86_64
References: <4F25BD09.3060607@lwfinger.net> <1327924292.6683.YahooMailClassic@web29506.mail.ird.yahoo.com> <20120130183924.GA2493@tuxdriver.com>
In-Reply-To: <20120130183924.GA2493@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2012 12:39 PM, John W. Linville wrote:
> On Mon, Jan 30, 2012 at 11:51:32AM +0000, Hin-Tak Leung wrote:
>> --- On Sun, 29/1/12, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>
>>>> This may be a fedora-specific problem - I noticed that
>>> just after booting into the new fedora kernel
>>> (3.2.2-1.fc16.x86_64), I am getting a strange message from
>>> the kernel:
>>>>
>>>> rtl8187: Invalid hwaddr! Using randomly generated MAC
>>> address
>>
>>
>>> I just checked, and rtl8187 works fine with my RTL8187L
>>> using 3.3-rc1 from
>>> wireless-testing. I don't know where the problem occurs.
>>
>> Thanks for looking. It is mostly likely a fedora-specific problem then. Unless John has any idea, I'll eventually unpacking the fedora kernel source if the problem persists for another kernel.
>>
>> Cheers,
>> Hin-Tak
>>
>> P.S. Herton's e-mail seems to have changed.
>
> When I integrated compat-wireless into the Fedora kernels, I
> left it using the in-kernel eeprom_93cx6 driver.  Apparently some
> incompatiblity has krept-in, and several wireless drives stopped
> working.  I have changed the fedora kernels to use the version of
> eeprom_93cx6 now, so the next build should work alright.

John,

Thanks for chasing down this problem.

Larry

