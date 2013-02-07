Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58209 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab3BGJ0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 04:26:43 -0500
Received: by mail-qc0-f181.google.com with SMTP id a22so889578qcs.40
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 01:26:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL1G+-EFnW4Ftq7omTUfFOxTSnKEU8WhAM+azw_Q9yHMesufaA@mail.gmail.com>
References: <CAL1G+-HfPJnwvisiE5Vr0ihenwKzL3_QL40DLPP_PsPyv+nveQ@mail.gmail.com>
	<20130206192544.GH2148@tuxdriver.com>
	<CAL1G+-EFnW4Ftq7omTUfFOxTSnKEU8WhAM+azw_Q9yHMesufaA@mail.gmail.com>
Date: Thu, 7 Feb 2013 10:20:31 +0100
Message-ID: <CANKVOs-1GRoSerY4D8rpc6ZVj6DiwepTsx3F3fUEXE3qcAniLw@mail.gmail.com> (sfid-20130207_102650_425231_745CFBEC)
Subject: Re: wireless-regdb: Update regulatory rules for Serbia (RS) on 2.4
 and 5GHz
From: Robert Basic <robertbasic.com@gmail.com>
To: Ognjen Ikovic <ognjen.ikovic@lacitadelleing.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day all!

On 7 February 2013 09:54, Ognjen Ikovic
<ognjen.ikovic@lacitadelleing.com> wrote:
> Dear John,
>
> I am not familiar with the process of posting patches, so please find
> information You have required bellow:
>
> country RS:
>                  (2400 - 2483.5 @ 40), (N/A, 100 mW)
>                  (5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR
>                  (5470 - 5725 @ 20), (3, 1 W), DFS
>
> Link to the original regulatory document (I have found a version on English)
> can be found here:
> http://www.ratel.rs/upload/editor_files/File/Regulations/Rules/Rules%20on%20radio-stations%20for%20which%20radio-station%20licence%20is%20not%20required.pdf
>
> Please refer to tables on pages 9 and 10 of the provided document.
>

I have found the same document, but I also have found another one
http://www.ratel.rs/upload/documents/Plan_namene/Plan-namene-tabele.pdf
sadly it is available only in Serbian Cyrillic. This document shows
the "Allocation plan" of the RF ranges. On pages 217-221 it lists
"Broadband wireless networks for data transfer" from roughly 57GHz to
66GHz. Now, this being just a "plan" means that most likely in the
future it will indeed be at 60GHz, but it is not yet implemented. I
don't know how else to read these documents.

Maybe Ognjen can provide more insight into this.

Thanks!

Regards,
Robert
