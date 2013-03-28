Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53671 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3C1MQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 08:16:52 -0400
Received: by mail-wg0-f49.google.com with SMTP id e11so1486838wgh.16
        for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 05:16:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130328090323.GA1384@redhat.com>
References: <CAGmUV-ugMOOv_OhG4+0CcQqJF1-nfRPUNwGtnzNRodXMOqS-bA@mail.gmail.com>
 <CAGmUV-vhBavw5=fM=Xt-bJVLp2zZSghrfOcWgHsYt_97_wy+4Q@mail.gmail.com>
 <CAGmUV-v9Bpn53JNYvmLpChtK_1Zj+ms0JGZC0=Tyc96SGfngLw@mail.gmail.com>
 <515392AF.8070809@lwfinger.net> <CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com>
 <20130328090323.GA1384@redhat.com>
From: Ali Ustek <aliustek@gmail.com>
Date: Thu, 28 Mar 2013 12:16:11 +0000
Message-ID: <CAGmUV-vhi8r=2TO06Y735a2Ws43hLJqEYv+ztYMmL3AgVKiQfQ@mail.gmail.com> (sfid-20130328_131656_574596_16E2DA50)
Subject: Re: Fwd: Ralink RT3290 card not supported
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	1156363@bugs.launchpad.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I know it is supported after 3.6 but the kernel (3.9.rc4) I have from
Ubuntu upstream hasn't got it, that is the reason I have raised a bug
and trying to get it fixed.

On Thu, Mar 28, 2013 at 9:03 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Mar 28, 2013 at 08:18:37AM +0000, Ali Ustek wrote:
>> >> The wi-fi chip Ralink RT3290 is common in notebooks but is not
>> >> supported by linux-kernel
>
> This device is supported since 3.7 . You most likely compile kernel
> without CONFIG_RT2800PCI_RT3290.
>
> Stanislaw
