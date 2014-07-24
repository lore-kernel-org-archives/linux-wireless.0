Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:53938 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaGXQR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 12:17:58 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so3025312wes.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 09:17:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406217620.5015.2.camel@dcbw.local>
References: <CAAdc0hyDepy7zn+1TQsjcZpkSkQrwFhbkPBJoH0vYKqbqkktAg@mail.gmail.com>
 <1406217620.5015.2.camel@dcbw.local>
From: Jean-Marie Lemetayer <jeanmarie.lemetayer@gmail.com>
Date: Thu, 24 Jul 2014 18:17:37 +0200
Message-ID: <CAAdc0hwEokNR_vDeCO_Txv8j04Yh-M2n70FyH=auTRQSS9KF2w@mail.gmail.com> (sfid-20140724_181802_425224_8C8C682F)
Subject: Re: How to get RSSI periodically
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks great! The AVG_RSSI is all I need. Thanks

2014-07-24 18:00 GMT+02:00 Dan Williams <dcbw@redhat.com>:
> On Thu, 2014-07-24 at 17:25 +0200, Jean-Marie Lemetayer wrote:
>> Hi,
>>
>> I am looking for a way to get the RSSI of the SELECTED network with
>> the wpa_supplicant (2.1). To update periodically the status connection
>> icon of my app.
>>
>> I known that I can get it with the command: 'bss <bssid>' but it seems
>> that this information is updated only when perform a scan.
>>
>> Have I miss something simpler than doing a background scan on the freq
>> of the SELECTED network ?
>
> Try the SIGNAL_POLL control interface command (called "signal_poll" for
> wpa_cli).
>
> Dan
>
