Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:51896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbXKESkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 13:40:45 -0500
From: Andreas Schwab <schwab@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problem with wireless-2.6
References: <472F57A6.3020107@lwfinger.net>
Date: Mon, 05 Nov 2007 19:40:40 +0100
In-Reply-To: <472F57A6.3020107@lwfinger.net> (Larry Finger's message of "Mon\,
	05 Nov 2007 11\:49\:26 -0600")
Message-ID: <jepryolemv.fsf@sykes.suse.de> (sfid-20071105_184048_707335_805F69DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> I did the following set of steps:
>
> git clone --reference ~/linux-2.6 \
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.g=
it junk
>
> cd junk
> git checkout -b everything origin/everything
> git pull
> Warning: No merge candidate found because value of config option
>          "branch.everything.merge" does not match any remote branch f=
etched.
> No changes.

What do you get from `git remote show origin'?

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
