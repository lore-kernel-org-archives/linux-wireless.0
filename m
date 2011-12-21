Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49008 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1LUIxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 03:53:08 -0500
Received: by qcqz2 with SMTP id z2so4245466qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 00:53:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
	<1324424765.13074.281.camel@wwguy-huron>
	<CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
	<CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
	<CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
Date: Wed, 21 Dec 2011 09:53:07 +0100
Message-ID: <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com> (sfid-20111221_095311_319223_CE26A091)
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 9:03 AM, Cheng Renquan <crquan@gmail.com> wrote:
> On Tue, Dec 20, 2011 at 10:22 PM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>>> have reported http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2338
>>
>> Can you try with linux-3.2-rc6 and the attached patch in [1]?
>>
>> - Sedat -
>>
>> [1] http://lkml.org/lkml/2011/12/17/14
>
> Is it already in iwlwifi.git? I'm gonna test it when I'm in office,
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi.git

/me confused...
Your subject is/was " ...linux 3.2-rcX iwlwifi driver's problem...",
now you are talking about iwlwifi.git.
Not sure what's the base of iwlwifi.git, but I guess it is wireless-testing?
BTW; what do you meant by 3.2-rcX, what is X? -rc1, -rc2...-rc6?
Which of those -rcX are affected?

- Sedat -
