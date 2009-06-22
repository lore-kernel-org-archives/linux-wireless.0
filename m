Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:55382 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZFVU6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 16:58:54 -0400
Received: by gxk10 with SMTP id 10so5785608gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 13:58:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3FDAC2.7020209@gmail.com>
References: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com>
	<4A3FDAC2.7020209@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Jun 2009 13:58:37 -0700
Message-ID: <43e72e890906221358m4a32d747ge67a5af2f74841e0@mail.gmail.com>
Subject: Re: [ath9k-devel] Pending ath9k bugs June, 2009
To: Dmitri Seletski <drjoms@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	gaurav.jauhar@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 22, 2009 at 12:25 PM, Dmitri Seletski<drjoms@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> We're down to 2 kernel.org bug reports for ath9k:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=13581
>> "ath9k doesn't work with newer kernels"
>> This is a regression between 2.6.29 and 2.6.30, someone needs to look at this.
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=13141
>> "AR5008/DWA-552 - Very slow"
>> Patches have been supplied, needs user feedback.
>>
>> If you are aware of any other issues please do report.
>>
>>   Luis
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>
> Hello Luis,
> Was that problem i was bothering you with being solved?

Oh no, thanks for the reminder, that is another outstanding issue. Can
you provide the pcap output.


> I have attempted to install fresh drivers, but i get:
>
>  make
> /bin/sh: line 0: test: -ge: unary operator expected
> /bin/sh: line 0: test: -le: unary operator expected

Hm, some script may not be using /bin/bash appropriately, but you may
just want to rm -f /bin/sh && ln -s /bin/bash /bin/sh for now.

  Luis
