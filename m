Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34956 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbbGGXnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 19:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <559BFB19.2080700@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <558EB4DE.3080406@users.sourceforge.net> <20150707023103.GA22043@kroah.com>
 <559B6FF8.9010704@users.sourceforge.net> <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com>
 <559B85CD.6040200@users.sourceforge.net> <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
 <559BBDD6.7040808@users.sourceforge.net> <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 8 Jul 2015 09:43:17 +1000
Message-ID: <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com> (sfid-20150708_014407_621905_7650812C)
Subject: Re: Clarification for the use of additional fields in the message body
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Frans Klaver <fransklaver@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Park <chris.park@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Wed, Jul 8, 2015 at 2:15 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> I can't remember ever changing or explicitly preserving the commit date.
>> I don't think I care enough.
>
> Would any more software developers and maintainers like to share
> their experiences around such details?
>
> When do commit timestamps become relevant as a documentation item
> for contribution authorship?

They are never relevant.

"When" a commit happened is never relevant except in relation to other
things, at which point the actual date and time is almost completely
irrelevant.

Just submit your patches using git-format-patch or git-send-email and
friends. There's a file in the documentation directory of the kernel
tree describing submitting patches and email client setup. Read them
both, do what they say without anything extra.

>> Remembering the author separately from the committer is something
>> git does by design anyway.
>
> Do you usually just reuse a procedure from a well-known command
> for which a description is provided like the following?
> http://git-scm.com/docs/git-am
> '…
> "From: " and "Subject: " lines starting the body override
> the respective commit author name and title values
> taken from the headers.
> …'
>
> Will further fields be eventually mentioned there?

Why? Just do what is described in SubmittingPatches. Your attempts to
"improve" on the system are unnecessary and annoying people. The
instructions there are the recommended way to do things for a reason.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
