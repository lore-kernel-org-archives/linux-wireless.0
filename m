Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:53054 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETSsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 14:48:33 -0400
Received: by mail-la0-f46.google.com with SMTP id ec20so752527lab.5
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 11:48:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400610273.4474.6.camel@jlt4.sipsolutions.net>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
 <20140520142453.GB13981@tuxdriver.com> <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
 <20140520180832.GD13981@tuxdriver.com> <1400610273.4474.6.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 11:48:11 -0700
Message-ID: <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com> (sfid-20140520_204836_984391_02EA35C2)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 11:24 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-05-20 at 14:08 -0400, John W. Linville wrote:
>
>> > I can add support for version 19 and 20 in one crda. I am not sure
>> > this is the best option.
>> > BTW what about versions < 19? How do we handle this this days?
>>
>> What about older CRDA with newer wireless-regdb?  Do we need to worry about that?
>
> I think we should, but if we can't then at least can we cut to an
> extensible format?

Janusz,

this is in short part of the work I expect to be dealt with as part of
the change. What I think we should strive for since we have control
over the format, is have extensions which upkeep old CRDA versions
working, and only if new CRDA is present would we use the new
attributes. Please see if this is possible.

  Luis
