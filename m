Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:54650 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3GaWEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 18:04:20 -0400
Message-ID: <51F9807A.6080000@uni-dortmund.de> (sfid-20130801_000423_273546_D009E065)
Date: Wed, 31 Jul 2013 23:24:10 +0200
From: Thomas Klute <thomas2.klute@uni-dortmund.de>
MIME-Version: 1.0
To: Michael McElroy <mikem388@gmail.com>
CC: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: CLI scan tool needed
References: <CAJt7DwytQzEMzn9way1z5ag-vo=GsYF72uvmAJEcJeJs=Y-hfw@mail.gmail.com> <CABPxzYJQB_Lsi4aYkSfvULEgToECAdfZfJCtpm1u4Fo7ibc02g@mail.gmail.com> <CAJt7DwzwyOKso_zNyemnX0LdXvtrWiuoaRJ8dnN8FKVjxiaayg@mail.gmail.com>
In-Reply-To: <CAJt7DwzwyOKso_zNyemnX0LdXvtrWiuoaRJ8dnN8FKVjxiaayg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 31.07.2013 22:51, schrieb Michael McElroy:
> Thanks Krishna, but all it returns is OK. Running the version 2.0 of
> wpa_supplicant.

I think the command you want is "scan_results" instead of "scan", so
"wpa_cli -i <interface> scan_results" over all. ;-)

> On Wed, Jul 31, 2013 at 4:30 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Wed, Jul 31, 2013 at 11:57 PM, Michael McElroy <mikem388@gmail.com> wrote:
>>> Using the backports project, I have one of the latest ralink driver
>>> going on an arm processor running 2.6.29 along with all nl80211 parts.
>>> Works great, thank you! The last piece I need is to get the to SSID
>>> list, their security protocols, and signal strength. I'm looking for
>>> output similar to 'wilist scanning'. 'iw scan' gives a lot of info but
>>> not quite what I need without a lot of massaging.
>>
>> "wpa_cli -i <interface> scan"
>> this should give you the required info, if you are already running the
>> wpa_supplicant.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
