Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:33356 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3LQHOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 02:14:43 -0500
Received: by mail-we0-f176.google.com with SMTP id w62so5675090wes.35
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 23:14:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJSBagxbz4nd8=Qt_HbG4ecqe=-cbzi0N4JDPCwDE42Mg@mail.gmail.com>
References: <CABPxzYJSBagxbz4nd8=Qt_HbG4ecqe=-cbzi0N4JDPCwDE42Mg@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 17 Dec 2013 12:44:22 +0530
Message-ID: <CABPxzYLu+yjkfsi13BXG8sKoySu_CwtN+uSgwwYdiXdEq8sGMw@mail.gmail.com> (sfid-20131217_081446_724697_1A03DF60)
Subject: Re: CRDA: Build Fail: Database signature verification failed
To: John Linville <linville@tuxdriver.com>,
	Luis Rodriguez <mcgrof@do-not-panic.com>
Cc: wireless-regdb@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 17, 2013 at 12:20 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> Hi,
>
> With the latest git source, i am seeing a build failure with the below error.
>
>   LD   crda
>   CC   intersect.o
>   LD   intersect
>   CC   regdbdump.o
>   LD   regdbdump
>   CC   db2rd.o
>   LD   db2rd
>   CC   optimize.o
>   LD   optimize
>   CHK  /usr/lib/crda/regulatory.bin
> Database signature verification failed.
> Invalid or empty regulatory file, note: a binary regulatory file should be used.
> make: *** [verify] Error 234
>
> Is there something wrong with the certificate?
>
Additional info:

# regdbdump /usr/lib/crda/regulatory.bin
Database signature verification failed.
#  ls -l /usr/lib/crda/regulatory.bin
-rw-r--r-- 1 root root 3344 Dec 16 17:34 /usr/lib/crda/regulatory.bin

regualtory.bin copied from wireless-regdb latest git.
