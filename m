Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbcEUDNM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 23:13:12 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
	<wrfjinyayf2i.fsf@redhat.com>
	<CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com>
	<wrfj4m9svn35.fsf@redhat.com>
	<CAOw_LSGsLVhXVvqwQD7J4ZJSL4jq8+KE-0ZMMXa5YP12Nb3dCA@mail.gmail.com>
	<CAOw_LSGnjhOO4hfPk9KttkFtLyT6XLxa92Cj=eKq6zgQ1at-RQ@mail.gmail.com>
Date: Fri, 20 May 2016 23:13:10 -0400
In-Reply-To: <CAOw_LSGnjhOO4hfPk9KttkFtLyT6XLxa92Cj=eKq6zgQ1at-RQ@mail.gmail.com>
	(Daniel Lenski's message of "Fri, 20 May 2016 13:54:10 -0700")
Message-ID: <wrfj1t4wt86x.fsf@redhat.com> (sfid-20160521_051345_281547_9FE0B585)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> On Fri, May 20, 2016 at 1:50 PM, Daniel Lenski <dlenski@gmail.com> wrote:
>> Am I understanding your idea correctly? To put a loop around the 8051
>> reset and the firmware polling loop, with a delay between failure and retry?
>
> That was some sloppy pseudo-code by me... here's what I think you're
> suggesting:

Actually I was more thinking along resetting it properly before tryinhg
to launch the firmware. Ie. before enabling execution.

Cheers,
Jes
