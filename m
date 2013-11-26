Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:33377 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab3KZSMA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 13:12:00 -0500
Message-ID: <5294E46C.40102@erley.org> (sfid-20131126_191204_710876_1060F187)
Date: Tue, 26 Nov 2013 12:11:56 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: matt emery <matt@x204.com>, linux-wireless@vger.kernel.org
Subject: Re: Fwd: Intel 7260
References: <CAKnB8xgAVp+Ti597RN4_kgPLgXpW1JCr4SQaqfqCzy5A4=o3Ow@mail.gmail.com> <CAKnB8xh6tWFdiL4kBQ5r3J_YgiiwhHhvQEqC+9F7c=3eAsrYbg@mail.gmail.com>
In-Reply-To: <CAKnB8xh6tWFdiL4kBQ5r3J_YgiiwhHhvQEqC+9F7c=3eAsrYbg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2013 06:28 AM, matt emery wrote:
> Hi,
>
> I hope you can help, I am having problems getting N with new Dual band
> wireless ac 7260 pci express half mini card, manufacturer code
> 7260.HMWWB
>
> lspci: 03:00.0 Network controller: Intel Corporation Device 08b1 (rev 73)
>
> Kernel: 3.12.0-031200-generic
>
> firmware: -rw-r--r-- 1 root root 682892 Nov 26 12:10 iwlwifi-7260-7.ucode
> from here; http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-7260-ucode-22.0.7.0.tgz
>
> wlan0     IEEE 802.11abg  ESSID:"XXXX"
>            Mode:Managed  Frequency:2.412 GHz  Access Point: 06:XX:22:XX:ED:XX
>            Bit Rate=54 Mb/s   Tx-Power=16 dBm
>            Retry  long limit:7   RTS thr:off   Fragment thr:off

>            Encryption key:off

While I'm not certain about your AP or the 7260 driver, I believe 
802.11n technically requires WPA2 encryption.  Try turning that on and 
testing again.

>            Power Management:off
>            Link Quality=70/70  Signal level=-36 dBm
>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>            Tx excessive retries:1  Invalid misc:27   Missed beacon:0
>
>
> Let me know if you need anything else.
>
> Thanks
>
> matt
>
> Matthew Emery
> 07988 197 438
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

