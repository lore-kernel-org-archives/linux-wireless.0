Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:3025 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZDOABA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 20:01:00 -0400
Received: by fg-out-1718.google.com with SMTP id e12so854473fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 17:00:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910904141547h129f379aoc6f632a6858e981b@mail.gmail.com>
References: <69e28c910904141534w7ed9b36w817f1862ff015286@mail.gmail.com>
	 <1239748653.4205.27.camel@johannes.local>
	 <69e28c910904141547h129f379aoc6f632a6858e981b@mail.gmail.com>
Date: Wed, 15 Apr 2009 01:00:58 +0100
Message-ID: <3ace41890904141700g21ec5274l5a73b07a5a3591cc@mail.gmail.com> (sfid-20090415_020111_518437_C032912A)
Subject: Re: [PATCH RFC] mac80211: don't ask drivers to retry transmitting
	NO_ACK frames
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/14 G=E1bor Stefanik <netrolller.3d@gmail.com>:

>>> Patch also available as attachment in case Gmail linewraps it.
>>
>> You need to get a proper MUA.
>
> Well, if you know any MUA that does Gmail-style conversation
> threading, and can sync its conversations with the Gmail web interfac=
e
> (I need access to Gmail on the go, including from public computers
> where I can't install a MUA), tell me immediately. So far, I've seen
> no such thing.

Somewhere along the line, I discovered that in Gmail's web interface,
"Show original" under the "Reply" menu at the right-top corner of a
e-mail does what is needed - it takes a particular e-mail and open a
new tab, showing its content as text. I extracted a couple of Larry's
e-mails recently this way ("show original" then "save page as...") and
just "patch -p1" with the saved pages.

In other words, even when the recipient is using Gmail, there is no
need to send an extra attachment beyond what Linus dictates i.e. patch
in-line.

(how the sender *sends* a patch, is a different matter - cut-and-paste
with web mail or even a "proper" MUA like thunderbird just doesn't do
it without some wizardary, but I suppose most people just do it like
me, with git-send-email to send patches. The fact that git-send-mail
uses gmail for SMTP is just incidental).
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
