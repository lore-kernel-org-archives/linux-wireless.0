Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57439 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3GaVYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 17:24:09 -0400
Received: by mail-wi0-f174.google.com with SMTP id j17so5493391wiw.7
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jul 2013 14:24:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJt7DwzwyOKso_zNyemnX0LdXvtrWiuoaRJ8dnN8FKVjxiaayg@mail.gmail.com>
References: <CAJt7DwytQzEMzn9way1z5ag-vo=GsYF72uvmAJEcJeJs=Y-hfw@mail.gmail.com>
	<CABPxzYJQB_Lsi4aYkSfvULEgToECAdfZfJCtpm1u4Fo7ibc02g@mail.gmail.com>
	<CAJt7DwzwyOKso_zNyemnX0LdXvtrWiuoaRJ8dnN8FKVjxiaayg@mail.gmail.com>
Date: Wed, 31 Jul 2013 17:24:08 -0400
Message-ID: <CAJt7Dwyqn42Rx45mZZwGjPiqPsq=MMX8RhM_9OArmPO86JGTyQ@mail.gmail.com> (sfid-20130731_232413_822193_582C5980)
Subject: Re: CLI scan tool needed
From: Michael McElroy <mikem388@gmail.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Got it. Had to do a scan_results after the scan.

Thank you.

On Wed, Jul 31, 2013 at 4:51 PM, Michael McElroy <mikem388@gmail.com> wrote:
> Thanks Krishna, but all it returns is OK. Running the version 2.0 of
> wpa_supplicant.
>
>
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
