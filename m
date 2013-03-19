Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:59558 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934172Ab3CSWJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 18:09:34 -0400
Received: by mail-ia0-f178.google.com with SMTP id y10so845698iak.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 15:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130312095826.GB1383@redhat.com>
References: <513E34FD.8090606@winsoft.pl> <CAJZjf_zfi3Eph2nnn+qJfGt3wGWJEFGxLuJtXAnb+s-Q9nrzgg@mail.gmail.com>
 <20130312095826.GB1383@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 19 Mar 2013 22:09:13 +0000
Message-ID: <CAJZjf_yLFUTxMeEMUHuX7CsSeRw=RH5v=YjBrWt=a-=sMmFdbw@mail.gmail.com> (sfid-20130319_230942_545885_CD0D5BF7)
Subject: Re: iwlegacy iwl3945 unable to connect to any hotspots on 3.9.0-rc1/rc2
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 12, 2013 at 9:58 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Mar 12, 2013 at 08:30:47AM +0000, Pedro Francisco wrote:
>> On Mon, Mar 11, 2013 at 7:48 PM, Krzysztof Kolasa <kkolasa@winsoft.pl> wrote:
>> > Hotspots are visible and are working OK but wifi card can't connect.
>> >
>>
>> Hit this bug also, on the GNOME-3.7.90.iso (based on FC19 testing
>> ISO), "Can't stop Rx DMA." and friends.
>>
>> -snip
>
> I'm just tested 3.9-rc2 and have the same problems (including
> dma map warning). So I don't need debug logs for that.
> However still I would like to see 3.8 logs from Zdenek.

Just checking, this problem reported above is independent from the DMA
map warning, right?

( I tested with 3.9.0-0.rc3.git0.3.fc19.i686.PAE :
Mar 19 18:17:05 s2 kernel: iwl3945 0000:02:00.0: Queue 4 stuck for 2495 ms.
(...)
Mar 19 18:17:13 s2 kernel: iwl3945 0000:02:00.0: Microcode SW error
detected. Restarting 0x82000008.
(...)
Mar 19 18:17:13 s2 kernel: iwl3945 0000:02:00.0: Status: 0x000202E4, count: 1 ).
