Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50327 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbbGHJ3A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 05:29:00 -0400
Subject: Re: Clarification for the use of additional fields in the message
 body
To: Julian Calaby <julian.calaby@gmail.com>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <558EB4DE.3080406@users.sourceforge.net> <20150707023103.GA22043@kroah.com>
 <559B6FF8.9010704@users.sourceforge.net>
 <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com>
 <559B85CD.6040200@users.sourceforge.net>
 <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
 <559BBDD6.7040808@users.sourceforge.net>
 <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net>
 <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com>
 <559CCC9D.8050606@users.sourceforge.net>
 <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com>
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
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <559CED4C.1080402@users.sourceforge.net> (sfid-20150708_112951_124731_ED78304D)
Date: Wed, 8 Jul 2015 11:28:44 +0200
MIME-Version: 1.0
In-Reply-To: <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If it's harmless, then no, but in this case, people are questioning
> why you're adding it as it adds no value

Some Git software developers care to keep the information complete
for the author commit.


> to anyone and makes it look like you don't know what you're doing.

I specify message field overrides in my update suggestions intentionally.


> The issue is that the headers you're adding, From: and Date: are unnecessary.

We have got different opinions about the purpose.


> The From: header you add is unnecessary as your email's From: header
> has the exact same information.

I would like to point out that there is a slight difference in my use case.


> The reason it's there is because sometimes people forward patches on
> from other people, e.g. if I were to resend one of your patches,
> I'd add a From: header to the body of the email so it'd be credited to you.

I am also interested in such an use case.


> The Date: header you add is unnecessary as git-format-patch sets the
> date header in the email it produces to the author date stored in the commit.

How do you think about my extra patch preparation for the mentioned
mail forwarding?


> So if you're sending your patches in emails produced by git-format-patch,
> there's absolutely no reason to include it.

I disagree here to some degree.

The difference in suggested commit timestamps of a few minutes might look
negligible for some patches. There are few occasions where the delay between
a concrete commit and its publishing by an interface like email
can become days.


> They are both almost completely irrelevant for most workflows as people
> are less interested in when a commit was made and more interested in what
> release it's in, how it was merged, etc. All of which should be
> determined without using the timestamp.

How often will it matter who made and published a change first?


> To be honest, I've only ever used that timestamp for reporting
> purposes at work, and I'd be surprised if anyone was doing anything
> other than that with them.

Thanks for your detailed feedback.


> How would you feel if someone came in to your place of work
> and told you to change how you do the job you've been doing for years
> without a good reason?

You might feel uncomfortable for a moment if you would interpret
such a suggestion as a personal attack.

I guess that I point only a few technical details out which can change
the popularity of existing functionality from the Git software.

Regards,
Markus
