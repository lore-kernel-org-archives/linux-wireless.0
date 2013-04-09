Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51636 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765118Ab3DIPcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:32:36 -0400
Received: by mail-ob0-f170.google.com with SMTP id uy19so4969066obc.29
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 08:32:35 -0700 (PDT)
Message-ID: <51643491.80302@lwfinger.net> (sfid-20130409_173240_980077_089FBF33)
Date: Tue, 09 Apr 2013 10:32:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Brillault <gentoo@lerya.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
References: <513A960B.2020304@lwfinger.net> <20130309113222.GA3009@Fea.lerya.net> <513B7E58.9000505@lwfinger.net> <20130311183825.GG3009@Fea.lerya.net> <20130313080048.GB3484@Fea.lerya.net> <20130317141201.GA2557@Fea.lerya.net> <20130325182910.GA10274@Fea.lerya.net> <5150A15F.20600@lwfinger.net> <20130325195104.GA11212@Fea.lerya.net> <5150AE0F.2040306@lwfinger.net> <20130409094542.GA26503@Fea.lerya.net>
In-Reply-To: <20130409094542.GA26503@Fea.lerya.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2013 04:47 AM, Vincent Brillault wrote:
> Hi again :)
>
> On Mon 25.Mar'13 at 15:05:35 -0500, Larry Finger wrote:
>> I will let you change that G to a B and test some more. If all goes well, then I
>> will not need to set up that test bed, but at least I have the necessary details
>> if ever required.
>
> I changed it from G to B. Now the rate (in iwconfig) is fixed to 11
> Mb/s, but that's not a problem as you said it's not the real rate. I
> didn't see any warning on module loading since that modification :)
>
> I still have the deconnection/reconnection issue. After looking on the
> reason, I think I have found a bug. Please look at the patched included
> in this mail: I think the rtlpriv->link_info.num_rx_inperiod is set to 0
> too early, as the '/* <4> roaming */' part uses it to see if the AP is
> still alive. What do you think ?

Does that change help your issue?

Larry


