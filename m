Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:50979 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbbAZVct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 16:32:49 -0500
Received: by mail-ob0-f171.google.com with SMTP id va2so10185245obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 13:32:48 -0800 (PST)
Message-ID: <54C6B27F.2030209@lwfinger.net> (sfid-20150126_223301_644553_2D8FE6EB)
Date: Mon, 26 Jan 2015 15:32:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Burton Williams <burton.b.williams@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ee issues
References: <CANPw_EgGaG=NT7FK-m93A-Fp80cyU6nTmfLV0wxiU10JT2HfKg@mail.gmail.com>
In-Reply-To: <CANPw_EgGaG=NT7FK-m93A-Fp80cyU6nTmfLV0wxiU10JT2HfKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2015 02:47 PM, Burton Williams wrote:
> Hi All -
>
> I am having problems with getting my wireless card to work. Here is what i did.
>
> I downloaded backports 3.18.1 and compiled and installed the wifi package
> against my 3.17.8 kernel. (I'm running FC21). Then i modprobe -r r8192ee and
> modprobe rtl8192ee. On first attempt i was able to connect to a wifi network and
> see a link speed of more than 6mbs. (144 to be exact) So way better than i was
> seeing before. I however did not see the network that is broadcasting on 5ghz.
> Attached are copies of my dmesg from modprobe fwd.
>
> Please let me know if I can do something else, or if i did something
> incorrectly. Any help is appreciated.
>
> Hardware is t440s running FC21 kernel   3.17.8-300.fc21.x86_64

To the best of my knowledge, the RTL8192EE chip has no 5 GHz radio, thus there 
is no way you could see a 5 GHz AP. I will recheck that with Realtek and let you 
know if my information is wrong.

Larry

