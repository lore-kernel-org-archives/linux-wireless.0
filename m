Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:37641 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764744AbdKRPTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 10:19:54 -0500
Received: by mail-ot0-f169.google.com with SMTP id s4so4399725ote.4
        for <linux-wireless@vger.kernel.org>; Sat, 18 Nov 2017 07:19:54 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: rosenp@gmail.com,
        =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>,
        linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <1510981609.5145.0.camel@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4e2cf93a-4a3c-af1c-df1c-de8f234d615d@lwfinger.net> (sfid-20171118_162006_077000_ACEA4974)
Date: Sat, 18 Nov 2017 09:19:52 -0600
MIME-Version: 1.0
In-Reply-To: <1510981609.5145.0.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/17/2017 11:06 PM, rosenp@gmail.com wrote:
> On Fri, 2017-11-17 at 09:16 +0100, Rákosi Gergely wrote:
>> Hello,
>>
>> I'm trying to use rtl8723be wifi on Fedora27 but I still get
>> continuosly
>> disconnection. The error in the dmesg is "Init MAC failed"
>> I tried with the following module options too : "fwlps=0 swlps=0" and
>> the variant of "ant_sel=1 or 2 or 0"
>> I downloaded the git files from your repo, and do the usual make,make
>> install, and modprobe stuffs, and then restart the notebook, but I
>> get
>> the same result.
>>
> 
> Could try blacklisting rtlwifi. That way it uses rtl8xxxu.

Ignore this suggestion. The RTL8723BE is NOT supported by rtl8xxxu. By the way, 
that "u" means that the driver is for USB devices. The "E" at the end of yours 
means PCIe!

Larry
