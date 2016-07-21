Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37041 "EHLO
	mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbcGUMex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 08:34:53 -0400
Received: by mail-it0-f43.google.com with SMTP id f6so16024055ith.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2016 05:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c18d3a077345402d83a4d12f1d75f07d@SC-EXCH04.marvell.com>
References: <CAEOnXSfd6K36cOcUfqy8rBT27TbH9PGy7U4z3TU0N2YWc7GXqA@mail.gmail.com>
 <efa3441022124e74af56753a70041eee@SC-EXCH04.marvell.com> <CAD3r-iQScbuUiGiF3uDKzMk-0mycG3WVFDGaYCy6aPxAEjq3mg@mail.gmail.com>
 <c18d3a077345402d83a4d12f1d75f07d@SC-EXCH04.marvell.com>
From: Luana Borgia <luanaborgia1969@gmail.com>
Date: Thu, 21 Jul 2016 14:34:52 +0200
Message-ID: <CAD3r-iSu5TSQxQckp30ZE1cyOC7tsJtmZbQ911bd6KQjOP5CaA@mail.gmail.com> (sfid-20160721_143457_810974_6A5E43DB)
Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nestor Machno <nestor.machno89@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,
if I understood correctly you are working to solve the issue related
to ibss-rsn (wpa2 in adhoc), I'm I right?
What about the alternative WPA mechanism with wpa-none instead? Fix it
shouldn't be simpler than RSN?

Thanks for update and
best regards.
Luana

2016-07-21 11:05 GMT+02:00 Amitkumar Karwar <akarwar@marvell.com>:
> Hi Luana,
>
>> From: Luana Borgia [mailto:luanaborgia1969@gmail.com]
>> Sent: Wednesday, July 20, 2016 6:53 PM
>> To: Amitkumar Karwar
>> Cc: Nestor Machno; linux-wireless@vger.kernel.org
>> Subject: Re: mwifiex+wpa_supplicant cannot set up WPA/WPA2 ADHOC
>>
>> Hi Amitkumar,
>> any news about this issue? I've the same problem also..
>>
>> Security a part, we can't leave the WIFI open or just with WEP because
>> we get too many not trusted connection that consume a lot of our
>> bandwidth
>>
>
> We are still working on this. With some driver changes, we are able to RSN IE in transmitted frames, but 4 way handshake doesn't occur.
>
> Regards,
> Amitkumar
