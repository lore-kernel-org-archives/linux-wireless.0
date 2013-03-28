Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:35020 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3C1JT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 05:19:28 -0400
Received: by mail-qe0-f50.google.com with SMTP id k5so5061161qej.37
        for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 02:19:28 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130328090323.GA1384@redhat.com>
References: <CAGmUV-ugMOOv_OhG4+0CcQqJF1-nfRPUNwGtnzNRodXMOqS-bA@mail.gmail.com>
	<CAGmUV-vhBavw5=fM=Xt-bJVLp2zZSghrfOcWgHsYt_97_wy+4Q@mail.gmail.com>
	<CAGmUV-v9Bpn53JNYvmLpChtK_1Zj+ms0JGZC0=Tyc96SGfngLw@mail.gmail.com>
	<515392AF.8070809@lwfinger.net>
	<CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com>
	<20130328090323.GA1384@redhat.com>
Date: Thu, 28 Mar 2013 10:19:27 +0100
Message-ID: <CA+icZUVzdxoDvontxSR99Jxu1UY88OG4xCCjsKErXBpmLzH_+g@mail.gmail.com> (sfid-20130328_101933_108856_680DBDE2)
Subject: Re: Fwd: Ralink RT3290 card not supported
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ali Ustek <aliustek@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	1156363@bugs.launchpad.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 10:03 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Mar 28, 2013 at 08:18:37AM +0000, Ali Ustek wrote:
>> >> The wi-fi chip Ralink RT3290 is common in notebooks but is not
>> >> supported by linux-kernel
>
> This device is supported since 3.7 . You most likely compile kernel
> without CONFIG_RT2800PCI_RT3290.
>

Hi Ali,

your kernel-config (self-compiled or the one of your $distro) and
dmesg logs are always helpful, the same to lspci/lsusb outputs.
And... informations to your $distro plus used your
$network-userspace-apps like network-manager (NM), wpa-supplicant etc.
are helpful... if you want your issue be tracked... successfully :-).

Check also docs section for debugging the different wifi-drivers on
<wireless.kernel.org>.

Hope this helps you!

Regards,
- Sedat -

> Stanislaw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
