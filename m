Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:57437 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaETN0u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 09:26:50 -0400
Received: by mail-la0-f42.google.com with SMTP id el20so394164lab.29
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 06:26:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
Date: Tue, 20 May 2014 15:26:48 +0200
Message-ID: <CALhHN=rLpBt-aTNDSbO6BO-TwFYuHf79=rpsTetysBrW_D47cA@mail.gmail.com> (sfid-20140520_152703_370909_DC8595CD)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2014 09:33, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> On Fri, May 9, 2014 at 1:40 AM, Janusz Dziedzic
> <janusz.dziedzic@tieto.com> wrote:
>> Introduce support for setting DFS CAC time
>> in milliseconds.
>>
>> Eg.
>> (5250 - 5330 @ AUTO), (20), (60000), DFS
>>
>> will setup CAC 60 seconds CAC time.
>
> Can you elaborate whether or not this will require a bump on CRDA  and
> issuing of two new wireless-regdb files for the different versions on
> the commit log?
>
Yes, sure - will add this.

BTW, probably you know, why we decide to split usermode regulatory
code into crda, regdb? This required binary interface between them and
a lot of "not needed" code? Why we don't simply zip/sign db.tx code
and parse this direrctly in crda and use just one user mode project
for that.
What was the reason for have regulatory in binary file?

BR
Janusz
