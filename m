Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35609 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2DYEs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 00:48:27 -0400
Received: by iadi9 with SMTP id i9so1961445iad.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 21:48:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20375.22656.459433.717064@gargle.gargle.HOWL>
References: <CANK3ZEcGEs6xSn8tgniXCGVN50VadYaY2ZvV0Fis236O19nqNQ@mail.gmail.com>
	<CANK3ZEczOgsru2BZ=sLnYxx_3St872y0-qAbYBV-PkhpNioNxQ@mail.gmail.com>
	<20375.22656.459433.717064@gargle.gargle.HOWL>
Date: Tue, 24 Apr 2012 21:48:27 -0700
Message-ID: <CANK3ZEcr8-m3DM2kOpmEeOB1=OoSaUhDHm2PiWjXqn2jSnXJtg@mail.gmail.com> (sfid-20120425_064831_413134_C22009C3)
Subject: Re: Survey dump does not seem to work with SONY USB Wireless LAN
 Adapter UWA-BR100
From: Aseem Sharma <aseem.sharma19@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith,

Appreciate the quick response.
Is there a plan to add this functionality in ath9k_htc driver?
If yes, it would be great if you can share a tentative date by when
this functionality will be available.
If no, then is there any other way of retrieving this information.

Thanks once again.

-Aseem





On Tue, Apr 24, 2012 at 6:50 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Aseem Sharma wrote:
>> Hello,
>>
>> I was previously using Cisco Aironet wireless adapter (it uses ath5k
>> driver); using which I was able to get the survey dump using the following
>> command:
>>
>> root@as75:~# iw phy phy0 interface add mon0 type monitor
>> root@as75:~# ifconfig mon0 up
>> root@as75:~# iw dev mon0 survey dump
>>
>> Survey data from mon0
>>         frequency:                      2412 MHz
>>         noise:                          -95 dBm
>>         channel active time:            11813 ms
>>         channel busy time:              300 ms
>>         channel receive time:           237 ms
>>         channel transmit time:          0 ms
>>
>> However, when I run the same commands after connecting SONY USB Wireless
>> LAN Adapter UWA-BR100 (which internally uses ath9k_htc driver) I do not seem
>> to get any output. Also, the command is successful (as I am running echo $?
>> which returns ‘0’)
>
> ath9k_htc currently doesn't support survey dump.
>
> Sujith
