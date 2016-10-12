Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:40227 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934110AbcJLUsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 16:48:25 -0400
Message-ID: <1476305293.2065.1.camel@embedded.rocks> (sfid-20161012_224829_890401_77B43B8A)
Subject: Re: TCP data throughput for BCM43362
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
        Brett Rudley <brudley@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Date: Wed, 12 Oct 2016 22:48:13 +0200
In-Reply-To: <c571ac91-ccd1-5e98-317f-eb3e56ad6b58@broadcom.com>
References: <1470429980.29489.10.camel@embedded.rocks>
         <CAF7Mx6o+WuQqtzuApMWQ8YAkLSX7xQ_H06xmO--RxFdwHwzLdQ@mail.gmail.com>
         <1BCE83A1-AA47-438D-BC47-05AE53D40121@embedded.rocks>
         <CA+8PC_f7VQMwBfQmZZ_vUtYtNJKVYzmFmxziAwoG8-iRUeW9Jw@mail.gmail.com>
         <1470492734.2120.0.camel@embedded.rocks>
         <6cdbbae7-8a56-6778-e886-68eeea7add15@broadcom.com>
         <1471873052.1683.27.camel@embedded.rocks>
         <40d15186-6ddf-a210-03de-2bbe21957f1d@broadcom.com>
         <1472505309.21429.3.camel@embedded.rocks>
         <1473860503.19492.19.camel@embedded.rocks>
         <27e007ed-57f6-4082-2f65-a11ba3b7f548@broadcom.com>
         <1474266984.7448.1.camel@embedded.rocks>
         <64180601-8d99-09fe-2db5-06c4ed7dd5d6@broadcom.com>
         <1474548738.11992.2.camel@embedded.rocks>
         <CAF7Mx6q+B4RoURNF5XxewjF9aVGCXg==XU0aDD6w+354yXZ70Q@mail.gmail.com>
         <F306F99A-DCEC-4C28-8805-AE0BA50D485F@embedded.rocks>
         <01642203-65dc-3b44-bbd4-2585bfdab15e@broadcom.com>
         <1476282457.1492.8.camel@embedded.rocks>
         <c571ac91-ccd1-5e98-317f-eb3e56ad6b58@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-12 at 21:08 +0200, Arend van Spriel wrote:

[snip]

> 
> You referred to 20 Mbps claim on wiced dev kit page at mouser so I
> assumed you were using that and it includes firmware. As you
> confirmed
> using firmware from linux-firmware repo this question does not
> matter.

Note, that a user reported "low" throughput on i.MX28 (same processor I
 use with BCM43362) using Qualcom/Atheros QCA 6124 only seeing 20MB
using iperf [1].

[1] https://community.nxp.com/thread/353921

Best regards
Jörg Krause
