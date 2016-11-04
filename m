Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752021AbcKDOG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 10:06:28 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: John Heenan <john@zgus.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine macpower
References: <cover.1477769750.git.john@zgus.com> <20161030102112.GA5789@cube>
        <wrfjpomidp1v.fsf@redhat.com>
        <CAAye0QN0s1S25tDPNWdM6fsVNaO-wLuSy_RoOSoXeuSMeD4oNA@mail.gmail.com>
        <wrfjzillsan3.fsf@redhat.com> <1478162497.1924.16.camel@perches.com>
Date: Fri, 04 Nov 2016 09:56:00 -0400
In-Reply-To: <1478162497.1924.16.camel@perches.com> (Joe Perches's message of
        "Thu, 03 Nov 2016 01:41:37 -0700")
Message-ID: <wrfjshr7mjrj.fsf@redhat.com> (sfid-20161104_150643_535063_5B8FEEB3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Sun, 2016-10-30 at 19:02 -0400, Jes Sorensen wrote:
>> Code is 80 characters wide, and comments are /* */ never the ugly C++
>> crap.
>
> You might look at the recent Linus Torvalds authored commit
> 5e467652ffef (?printk: re-organize log_output() to be more legible")
> which does both of those: c99 // comments and > 80 columns.
>
> Absolutes are for zealots.

What Linus does in his code, is totally up to him. What I pull into the
driver that *I* maintain, is up to me. It is perfectly normal to expect
submitters to respect the coding style of the piece of code they are
trying to edit.

Jes
