Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:37909 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3DOUGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 16:06:38 -0400
Received: by mail-wg0-f53.google.com with SMTP id z11so1248165wgg.8
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 13:06:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGmUV-tU6uSS2dW4vuNN7Zbm1qWk_0r3vkJ8crRAvygQ-+NuAA@mail.gmail.com>
References: <CAGmUV-ugMOOv_OhG4+0CcQqJF1-nfRPUNwGtnzNRodXMOqS-bA@mail.gmail.com>
 <CAGmUV-vhBavw5=fM=Xt-bJVLp2zZSghrfOcWgHsYt_97_wy+4Q@mail.gmail.com>
 <CAGmUV-v9Bpn53JNYvmLpChtK_1Zj+ms0JGZC0=Tyc96SGfngLw@mail.gmail.com>
 <515392AF.8070809@lwfinger.net> <CAGmUV-tCwDd7+g1k0=xnAx03bjxVnPXhf6uSU+Fa4Oo2EQPizA@mail.gmail.com>
 <20130328090323.GA1384@redhat.com> <CA+icZUVzdxoDvontxSR99Jxu1UY88OG4xCCjsKErXBpmLzH_+g@mail.gmail.com>
 <CAGmUV-tU6uSS2dW4vuNN7Zbm1qWk_0r3vkJ8crRAvygQ-+NuAA@mail.gmail.com>
From: Ali Ustek <aliustek@gmail.com>
Date: Mon, 15 Apr 2013 21:05:56 +0100
Message-ID: <CAGmUV-tdNzLHqtxHEa_9Z2xLpSw9w4aA_ujk=oT3qm2aKh8_xg@mail.gmail.com> (sfid-20130415_220649_297779_EE3D082E)
Subject: Re: Fwd: Ralink RT3290 card not supported
To: sedat.dilek@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have checked the Ubuntu kernel config on my laptop and it has
$ grep -i RT2800PCI /boot/config-3.8.0-18-generic
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2800PCI_RT3290=y

and I tried to compile the kernel myself to no avail.

any ideas?

On Thu, Mar 28, 2013 at 12:18 PM, Ali Ustek <aliustek@gmail.com> wrote:
> Hi Sedat,
>
> The kernel I am using is from Ubuntu and I am using NM.
>
> All the other logs I have attached on to launchpad bug
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1156363
> if that's any help at all.
>
> Thanks
>
> On Thu, Mar 28, 2013 at 9:19 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Thu, Mar 28, 2013 at 10:03 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>> On Thu, Mar 28, 2013 at 08:18:37AM +0000, Ali Ustek wrote:
>>>> >> The wi-fi chip Ralink RT3290 is common in notebooks but is not
>>>> >> supported by linux-kernel
>>>
>>> This device is supported since 3.7 . You most likely compile kernel
>>> without CONFIG_RT2800PCI_RT3290.
>>>
>>
>> Hi Ali,
>>
>> your kernel-config (self-compiled or the one of your $distro) and
>> dmesg logs are always helpful, the same to lspci/lsusb outputs.
>> And... informations to your $distro plus used your
>> $network-userspace-apps like network-manager (NM), wpa-supplicant etc.
>> are helpful... if you want your issue be tracked... successfully :-).
>>
>> Check also docs section for debugging the different wifi-drivers on
>> <wireless.kernel.org>.
>>
>> Hope this helps you!
>>
>> Regards,
>> - Sedat -
>>
>>> Stanislaw
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
