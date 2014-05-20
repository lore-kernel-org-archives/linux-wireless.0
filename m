Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:58412 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaETSBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 14:01:33 -0400
Received: by mail-la0-f53.google.com with SMTP id ec20so699725lab.40
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 11:01:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140520142453.GB13981@tuxdriver.com>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	<20140520142453.GB13981@tuxdriver.com>
Date: Tue, 20 May 2014 20:01:31 +0200
Message-ID: <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com> (sfid-20140520_200136_256218_92BC547F)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2014 16:24, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, May 20, 2014 at 12:33:51AM -0700, Luis R. Rodriguez wrote:
>> On Fri, May 9, 2014 at 1:40 AM, Janusz Dziedzic
>> <janusz.dziedzic@tieto.com> wrote:
>> > Introduce support for setting DFS CAC time
>> > in milliseconds.
>> >
>> > Eg.
>> > (5250 - 5330 @ AUTO), (20), (60000), DFS
>> >
>> > will setup CAC 60 seconds CAC time.
>>
>> Can you elaborate whether or not this will require a bump on CRDA  and
>> issuing of two new wireless-regdb files for the different versions on
>> the commit log?
>
> I would really prefer not to manage two regdb binary releases.
> Fear of that is what has kept me from merging this patch.
>
I can add support for version 19 and 20 in one crda. I am not sure
this is the best option.
BTW what about versions < 19? How do we handle this this days?

BR
Janusz
