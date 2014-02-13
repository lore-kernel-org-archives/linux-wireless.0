Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35239 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaBMWFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 17:05:21 -0500
Received: by mail-wi0-f171.google.com with SMTP id cc10so9321515wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 14:05:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEZsi7HnRxojt6=B3fy8uT2KHuVwzhzzvWV7Ykvr+fO_55Upkw@mail.gmail.com>
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
	<CAEZsi7GtEk2a5PvBCica0zvmGZNPqHK9XzZV2vma9nGDv1j7cw@mail.gmail.com>
	<CAEZsi7Fnw_u87W5cXhojMQg8hr6h5PEmwWU9Vh14zzKL6MY4og@mail.gmail.com>
	<CAEZsi7HnRxojt6=B3fy8uT2KHuVwzhzzvWV7Ykvr+fO_55Upkw@mail.gmail.com>
Date: Thu, 13 Feb 2014 23:05:20 +0100
Message-ID: <CAEZsi7Eg3AvFa=iYazPYVN=Q1RszwSESQVsjbmA7pJAWkmMK2g@mail.gmail.com> (sfid-20140213_230530_953558_60AACF40)
Subject: Fwd: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Vincent Thiele <vincentthiele@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---------- Forwarded message ----------
From: Vincent Thiele <vincentthiele@gmail.com>
Date: 2014-02-13 15:51 GMT+01:00
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
To: Larry Finger <Larry.Finger@lwfinger.net>


Today i tried kernel 3.13.2 native driver which now works as expected.
But after a while the connection gets interrupted and i need to
reconnect to my wlan. This behaviour is reproducable.
Best regards

2013-09-21 19:47 GMT+02:00 Vincent Thiele <vincentthiele@gmail.com>:
> Any news?
>
> 2013/9/12 Vincent Thiele <vincentthiele@gmail.com>:
>> Thank you very much. The vendor driver doesn't work with 3.8 or 3.9.
>> Therefore i use the patched vendor driver but with 3.10 or 3.11 even
>> the patched dkms driver doesn't work.
>>
>> 2013/9/12 Larry Finger <Larry.Finger@lwfinger.net>:
>>> On 09/12/2013 12:57 AM, Vincent Thiele wrote:
>>>>
>>>> No i tried your "ping-solution" with kernel 3.11 but it dosen't work.
>>>
>>>
>>> I just discovered that your device is a 300 Mbps unit, which implies a 2x2
>>> configuration. The only one of them that I have does not work with any Linux
>>> driver; however, some of the postings that I have read suggest that this one
>>> will work with the vendor driver.
>>>
>>> I just bought a TL-WN823N on E-Bay. I think the expected delivery is Sept.
>>> 16. Once I get it, I will try to see what I can learn.
>>>
>>> Larry
>>>
>>>
