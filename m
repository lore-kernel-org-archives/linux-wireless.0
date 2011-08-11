Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41929 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1HKOhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 10:37:08 -0400
Received: by yxj19 with SMTP id 19so1339241yxj.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 07:37:07 -0700 (PDT)
Message-ID: <4E43E910.7090001@lwfinger.net> (sfid-20110811_163715_025408_565190EA)
Date: Thu, 11 Aug 2011 09:37:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: kc@cobradevil.org
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu sometimes it can authenticate to ap
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org> <34676454425401d650be733a43191a53@cobradevil.org> <532595cb4d5ef910de54a4736ba76185@cobradevil.org> <4E41624E.3010904@lwfinger.net> <d3faeaf2e881a324b0ad3102c10e6131@cobradevil.org> <4E429C57.1040101@lwfinger.net> <30cc9c22bb40fb1e2bd2b9ef4692d167@cobradevil.org>
In-Reply-To: <30cc9c22bb40fb1e2bd2b9ef4692d167@cobradevil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2011 09:23 AM, kc@cobradevil.org wrote:
> I have now tried several compat files til may 28 but none of them seems to work
> with maverick at all. Do i need some updated files on the client to be able to
> use the new compat tree?
>
> I thought that the compat tree would work without changes on kernel from >
> 2.6.30 is that right?

I have no idea what maverick is. I suppose it to be some release of Ubuntu, but 
you really need to specify a kernel version, not a release name. Many of us do 
not use any Debian-based systems for very good reasons.

The compat tree will work without changes on any kernel on which it will 
compile, AS LONG AS THE REST OF THE KERNEL DOES NOT BREAK THE WIRELESS.

My full bisection ended up in am impossible result.

The only other thing I can add at the moment, is that rtl8192cu works with WEP 
encryption, thus the part that broke is WPA and WPA2.

Larry
