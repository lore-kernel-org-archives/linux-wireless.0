Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36435 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab3C1MTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 08:19:18 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm11so3315028wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Mar 2013 05:19:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+icZUVzdxoDvontxSR99Jxu1UY88OG4xCCjsKErXBpmLzH_+g@mail.gmail.com>
References: <CAGmUV-ugMOOv_OhG4+0CcQqJF1-nfRPUNwGtnzNRodXMOqS-bA@mail.gmail.com>
 <CAGmUV-vhBavw5=fM=Xt-bJVLp2zZSghrfOcWgHsYt_97_wy+4Q@mail.gmail.com>
 <CAGmUV-v9Bpn53JNYvmLpChtK_1Zj+ms0JGZC0=Tyc96SGfngLw@mail.gmail.com>
 <515392AF.8070809@lwfinger.net> <CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com>
 <20130328090323.GA1384@redhat.com> <CA+icZUVzdxoDvontxSR99Jxu1UY88OG4xCCjsKErXBpmLzH_+g@mail.gmail.com>
From: Ali Ustek <aliustek@gmail.com>
Date: Thu, 28 Mar 2013 12:18:37 +0000
Message-ID: <CAGmUV-tU6uSS2dW4vuNN7Zbm1qWk_0r3vkJ8crRAvygQ-+NuAA@mail.gmail.com> (sfid-20130328_131921_427029_8FF5ACE8)
Subject: Re: Fwd: Ralink RT3290 card not supported
To: sedat.dilek@gmail.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	1156363@bugs.launchpad.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sedat,

The kernel I am using is from Ubuntu and I am using NM.

All the other logs I have attached on to launchpad bug
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1156363
if that's any help at all.

Thanks

On Thu, Mar 28, 2013 at 9:19 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Mar 28, 2013 at 10:03 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Thu, Mar 28, 2013 at 08:18:37AM +0000, Ali Ustek wrote:
>>> >> The wi-fi chip Ralink RT3290 is common in notebooks but is not
>>> >> supported by linux-kernel
>>
>> This device is supported since 3.7 . You most likely compile kernel
>> without CONFIG_RT2800PCI_RT3290.
>>
>
> Hi Ali,
>
> your kernel-config (self-compiled or the one of your $distro) and
> dmesg logs are always helpful, the same to lspci/lsusb outputs.
> And... informations to your $distro plus used your
> $network-userspace-apps like network-manager (NM), wpa-supplicant etc.
> are helpful... if you want your issue be tracked... successfully :-).
>
> Check also docs section for debugging the different wifi-drivers on
> <wireless.kernel.org>.
>
> Hope this helps you!
>
> Regards,
> - Sedat -
>
>> Stanislaw
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
