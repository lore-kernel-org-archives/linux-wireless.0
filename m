Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sflc.info ([216.27.154.199]:42955 "EHLO mail.sflc.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYKZPyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 10:54:36 -0500
From: "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>
To: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ath5k-devel@lists.ath5k.org>, <ath9k-devel@lists.ath9k.org>
Cc: karen@softwarefreedom.org
Subject: Re: License of changes to ath5k/ath9k
References: <20081125210421.GF5950@tesla>
Date: Wed, 26 Nov 2008 09:59:25 -0500
In-Reply-To: <20081125210421.GF5950@tesla> (Luis R. Rodriguez's message of
	"Tue, 25 Nov 2008 13:04:21 -0800")
Message-ID: <87d4gi4joy.fsf@ebb.org> (sfid-20081126_165441_527464_129D45EE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote at 16:04 (EST) on Tuesday:

> We have been using the Changes-licensed-under tag [1] for ath5k
> development but for ath9k we tend to ask developers individually if
> they are willing submit their changes and any future ath9k changes
> under the ISC. We keep this for our records just in case you haven't
> read the Singed-off-by.  I think it'd be easier too if we ensure
> developers really read that document too and ensure they understand it
> and also understood why are are doing this.

> We'll keep using the ath5k Changes-licensed-under tag until we get
> advice from SFLC if we have done enough to ensure this is no longer
> necessary.

I should note that there's no specific magic to the
Changes-licensed-under tag; we developed with with Luis as a mechanism
and tool to do the the thing that mattered: Carefully catalog the fact
that each person who makes a change on an ISC-licensed codebase agrees
to keep the code under ISC license for later sharing with BSD folks.

There are probably a dozen methods you could use to do this job, and
really you should use whatever method works for the development team.
The only fundamental requirement is that it be rigorous, detailed and
complete.

Of course, if situations change and become more complicated, the Linux
Wireless team is welcome to contact me and Karen at the Software Freedom
Law Center for additional legal advice on this subject.

Bob Copeland wrote on at 16:28 (EST) on Tuesday:
> I don't consider any of my changes significant enough to confer
> copyright,

Most non-lawyers like myself are amazed to find how little it takes for
something to confer copyright.  If you did anything more than correct a
spelling error, it's always better to assume you have a copyright
interest in the work.  Sometimes, you'll be wrong, but more often than
not, it will turn out the thing that looked uncopyrightable actually
*is* copyrightable under the Draconian copyright laws that now exist in
most industrialized countries.

> However, if everyone + SFLC prefers that we strictly use
> Changes-licensed-under even if we don't claim copyright, then I'll
> happily add the tag generator script to a git commit hook :)

Yeah, exactly, it's an easy thing to do just to be sure.  The worst that
happens is that you didn't have copyright in the thing, and your consent
to the ISC licensing of the work wasn't actually needed, but you gave it
anyway.  (It's like saying: "I consent to you going to the store today".
You didn't need my consent, but it doesn't hurt that you have it.)  This
is far better than the alternative: that the consent was needed but it
wasn't given because it seemed the changes weren't copyrightable but
they actually were.


BTW, SFLC published a white paper on this issue that might be of interest:

http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html
-- 
Bradley M. Kuhn, Policy Analyst and Technology Director
                 Software Freedom Law Center
