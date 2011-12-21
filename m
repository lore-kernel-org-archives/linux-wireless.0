Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62195 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1LUGWT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 01:22:19 -0500
Received: by qcqz2 with SMTP id z2so4190259qcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 22:22:18 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
	<1324424765.13074.281.camel@wwguy-huron>
	<CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
Date: Wed, 21 Dec 2011 07:22:18 +0100
Message-ID: <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com> (sfid-20111221_072240_177127_2A26B68E)
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

On Wed, Dec 21, 2011 at 3:37 AM, Cheng Renquan <crquan@gmail.com> wrote:
> On Tue, Dec 20, 2011 at 3:46 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
>> Hi Renquan,
>>
>> Thanks you for reporting the issue.It will be greatly appreciated  if
>> you can enter a bug report in http://bugzilla.intellinuxwireless.org/.
>> Then we can assign engineer to look into the issue , also keep track of
>> the progress.
>>
>> Thanks
>> Wey
>
> have reported http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2338
>

Can you try with linux-3.2-rc6 and the attached patch in [1]?

- Sedat -

[1] http://lkml.org/lkml/2011/12/17/14
