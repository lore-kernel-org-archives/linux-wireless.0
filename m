Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41292 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaAXXCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 18:02:33 -0500
Received: by mail-la0-f46.google.com with SMTP id b8so3004752lan.5
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 15:02:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYLu+yjkfsi13BXG8sKoySu_CwtN+uSgwwYdiXdEq8sGMw@mail.gmail.com>
References: <CABPxzYJSBagxbz4nd8=Qt_HbG4ecqe=-cbzi0N4JDPCwDE42Mg@mail.gmail.com>
 <CABPxzYLu+yjkfsi13BXG8sKoySu_CwtN+uSgwwYdiXdEq8sGMw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 24 Jan 2014 15:02:11 -0800
Message-ID: <CAB=NE6U7zy8MeO4qLuWsEC_t69JKkS2=98crGrp4073=5WHU9Q@mail.gmail.com> (sfid-20140125_000237_055371_D30DB562)
Subject: Re: CRDA: Build Fail: Database signature verification failed
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 16, 2013 at 11:14 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Tue, Dec 17, 2013 at 12:20 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> Hi,
>>
>> With the latest git source, i am seeing a build failure with the below error.
>>
>>   LD   crda
>>   CC   intersect.o
>>   LD   intersect
>>   CC   regdbdump.o
>>   LD   regdbdump
>>   CC   db2rd.o
>>   LD   db2rd
>>   CC   optimize.o
>>   LD   optimize
>>   CHK  /usr/lib/crda/regulatory.bin
>> Database signature verification failed.
>> Invalid or empty regulatory file, note: a binary regulatory file should be used.
>> make: *** [verify] Error 234
>>
>> Is there something wrong with the certificate?
>>
> Additional info:
>
> # regdbdump /usr/lib/crda/regulatory.bin
> Database signature verification failed.
> #  ls -l /usr/lib/crda/regulatory.bin
> -rw-r--r-- 1 root root 3344 Dec 16 17:34 /usr/lib/crda/regulatory.bin
>
> regualtory.bin copied from wireless-regdb latest git.

John, what ever happened with this, I forget.

  Luis
