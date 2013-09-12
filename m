Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:48885 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3ILHlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 03:41:53 -0400
Received: by mail-la0-f45.google.com with SMTP id eh20so8228109lab.4
        for <linux-wireless@vger.kernel.org>; Thu, 12 Sep 2013 00:41:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52315E0C.9010806@lwfinger.net>
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
	<522E4315.4040806@lwfinger.net>
	<1378764913.31180.9.camel@dcbw.foobar.com>
	<CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com>
	<1378916091.1693.21.camel@dcbw.foobar.com>
	<52309B75.3010408@lwfinger.net>
	<5230A440.5050709@ilande.co.uk>
	<5230B573.9030800@lwfinger.net>
	<CAEZsi7G+FqUh2fBXLLR17qiBb1ggLu2+11aYRt2Wppr1gGK-Wg@mail.gmail.com>
	<52311E9A.7030902@lwfinger.net>
	<CAEZsi7F-RxaZJNaYi53kTtsQbxL4TU6DhTPo5v-O5ry=pawb_Q@mail.gmail.com>
	<52315E0C.9010806@lwfinger.net>
Date: Thu, 12 Sep 2013 09:41:52 +0200
Message-ID: <CAEZsi7GtEk2a5PvBCica0zvmGZNPqHK9XzZV2vma9nGDv1j7cw@mail.gmail.com> (sfid-20130912_094156_883849_F4E93654)
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Vincent Thiele <vincentthiele@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much. The vendor driver doesn't work with 3.8 or 3.9.
Therefore i use the patched vendor driver but with 3.10 or 3.11 even
the patched dkms driver doesn't work.

2013/9/12 Larry Finger <Larry.Finger@lwfinger.net>:
> On 09/12/2013 12:57 AM, Vincent Thiele wrote:
>>
>> No i tried your "ping-solution" with kernel 3.11 but it dosen't work.
>
>
> I just discovered that your device is a 300 Mbps unit, which implies a 2x2
> configuration. The only one of them that I have does not work with any Linux
> driver; however, some of the postings that I have read suggest that this one
> will work with the vendor driver.
>
> I just bought a TL-WN823N on E-Bay. I think the expected delivery is Sept.
> 16. Once I get it, I will try to see what I can learn.
>
> Larry
>
>
