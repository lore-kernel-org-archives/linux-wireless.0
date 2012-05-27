Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37463 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2E0PIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 11:08:54 -0400
Message-ID: <4FC2437C.9090106@candelatech.com> (sfid-20120527_170904_075958_57E413FA)
Date: Sun, 27 May 2012 08:08:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com> <20417.972.888113.821079@gargle.gargle.HOWL> <20417.1857.115550.807746@gargle.gargle.HOWL>
In-Reply-To: <20417.1857.115550.807746@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2012 09:39 AM, Sujith Manoharan wrote:
> Sujith Manoharan wrote:
>> I am using a DB120 as AP which has dual radio - AR9340/AR9300. The setup is
>> standard:

Do you have a link to anyone selling this AP, or is it just an
engineering sample as well?

I didn't have much luck finding it in google...  Is there a more specific
part number or manufacturer available?

I can't even find marketing type pages for AR9340, search results come up
empty at www.atheros.com :P

>> STA -------------->   AP ------------------->  CONSOLE
>>         wlan/OTA             gig-ethernet
>>
>>
>> The AP runs an internal BSP/SDK build and is positioned about 4-5 feet from
>> the Station. As for the HT parameters, HT40 and short-GI is enabled in both
>> bands.
>
> With UDP, these are the numbers I get:
>
> Server: [ iperf -i1 -s -u -l 8K ]
>
> [  3] 29.0-30.0 sec  38.9 MBytes   327 Mbits/sec   0.246 ms   10/ 4993 (0.2%)
> [  3] 30.0-31.0 sec  38.6 MBytes   323 Mbits/sec   0.260 ms   34/ 4970 (0.68%)
> [  3] 31.0-32.0 sec  39.3 MBytes   330 Mbits/sec   0.212 ms   14/ 5045 (0.28%)
> [  3] 32.0-33.0 sec  37.2 MBytes   312 Mbits/sec   0.229 ms   15/ 4777 (0.31%)
> [  3] 33.0-34.0 sec  39.0 MBytes   327 Mbits/sec   0.253 ms   13/ 5002 (0.26%)
>
> Client: [ iperf -i1 -c 172.16.0.10 -t 10000 -u -b 400M -l 8K ]
>
> [  3] 29.0-30.0 sec  39.0 MBytes   327 Mbits/sec
> [  3] 30.0-31.0 sec  38.9 MBytes   326 Mbits/sec
> [  3] 31.0-32.0 sec  39.4 MBytes   330 Mbits/sec
> [  3] 32.0-33.0 sec  37.3 MBytes   313 Mbits/sec
> [  3] 33.0-34.0 sec  39.1 MBytes   328 Mbits/sec

Those are nice results!  I'll try WPEA-127N as AP and STA and see what I get.

If you have any suggestions for other commercially available NICs or APs to try,
please let me know.

Thanks,
Ben


-- 
Ben Greear <greearbse@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
