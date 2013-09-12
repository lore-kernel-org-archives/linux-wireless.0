Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54133 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3ILGYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 02:24:14 -0400
Received: by mail-ob0-f181.google.com with SMTP id gq1so127783obb.12
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 23:24:14 -0700 (PDT)
Message-ID: <52315E0C.9010806@lwfinger.net> (sfid-20130912_082417_785330_A30B5F5B)
Date: Thu, 12 Sep 2013 01:24:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Thiele <vincentthiele@gmail.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com> <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com> <CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com> <1378916091.1693.21.camel@dcbw.foobar.com> <52309B75.3010408@lwfinger.net> <5230A440.5050709@ilande.co.uk> <5230B573.9030800@lwfinger.net> <CAEZsi7G+FqUh2fBXLLR17qiBb1ggLu2+11aYRt2Wppr1gGK-Wg@mail.gmail.com> <52311E9A.7030902@lwfinger.net> <CAEZsi7F-RxaZJNaYi53kTtsQbxL4TU6DhTPo5v-O5ry=pawb_Q@mail.gmail.com>
In-Reply-To: <CAEZsi7F-RxaZJNaYi53kTtsQbxL4TU6DhTPo5v-O5ry=pawb_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2013 12:57 AM, Vincent Thiele wrote:
> No i tried your "ping-solution" with kernel 3.11 but it dosen't work.

I just discovered that your device is a 300 Mbps unit, which implies a 2x2 
configuration. The only one of them that I have does not work with any Linux 
driver; however, some of the postings that I have read suggest that this one 
will work with the vendor driver.

I just bought a TL-WN823N on E-Bay. I think the expected delivery is Sept. 16. 
Once I get it, I will try to see what I can learn.

Larry


