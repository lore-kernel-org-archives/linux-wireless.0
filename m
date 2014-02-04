Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:40125 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBDDAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 22:00:11 -0500
Received: by mail-qc0-f176.google.com with SMTP id e16so12521782qcx.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 19:00:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52EF9C2E.5030202@opensuse.org>
References: <1391319050-100614-1-git-send-email-crrodriguez@opensuse.org>
 <1391424732.4488.4.camel@jlt4.sipsolutions.net> <1391424860.4488.6.camel@jlt4.sipsolutions.net>
 <52EF9C2E.5030202@opensuse.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 4 Feb 2014 13:59:48 +1100
Message-ID: <CAGRGNgUuTm7kbo23_F42Q-vD23vQ3ZWMnmBY1DQJpKvb=tWPYQ@mail.gmail.com> (sfid-20140204_040017_266801_324B600F)
Subject: Re: [PATCH] [iw] Make the build system automake based
To: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cristian,

On Tue, Feb 4, 2014 at 12:39 AM, Cristian Rodríguez
<crrodriguez@opensuse.org> wrote:
> El 03/02/14 07:54,  escribió:
>
>> On Mon, 2014-02-03 at 11:52 +0100, Johannes Berg wrote:
>>
>>> I *might* be open to switching to something like
>>> cmake
>>
>> [...] something *sane* like cmake [...]
>>
>> (FWIW, don't even argue that part about auto*, it's decidedly not sane
>> to have a build system that needs roughly two dozen versions installed
>> concurrently to build different software)
>>
>> johannes
>>
>
> Well, unfortunately we disagree on everything. cmake is NOT sane though I
> could write an equivalent in few minutes, read the book, been there, done
> that.. it sucks.
>
> Autotools does not require two dozen versions installed to build anything,
> this is a apparently an insanity found only in debian distributions.
>
> Looks like I am going to stop wasting keystrokes about now..people who have
> similar opinions invariably do not understand the problems faced by
> distributors or packagers.

Opinions will always differ.

Is there some way that the makefile could be improved / simplified to
meet your goals / requirements without a complete automake based
rewrite?

I understand that custom makefiles can be a maintenance burden, but if
you could describe the exact issue you're having, and maybe propose a
less invasive patch, you might get a more positive response. (By
"invasive", I mean increasing the build dependencies, not necessarily
changing a lot of code.)

Another option could be to add an automake build system in parallel
with the current make based one and offer to maintain it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
