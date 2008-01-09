Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:48218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYAIJot (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:44:49 -0500
From: Andreas Schwab <schwab@suse.de>
To: Pavel Roskin <proski@gnu.org>
Cc: bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge errors on 'everything'
References: <200801091043.02204.bruno@thinktube.com>
	<1199844835.3697.12.camel@dv>
Date: Wed, 09 Jan 2008 10:44:46 +0100
In-Reply-To: <1199844835.3697.12.camel@dv> (Pavel Roskin's message of "Tue\, 08
	Jan 2008 21\:13\:55 -0500")
Message-ID: <jek5mjgwoh.fsf@sykes.suse.de> (sfid-20080109_094453_251306_3D7F2711)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> You can clean up the consequences of the failed merge by running
> "git-reset --hard origin/everything" where "origin" is the name of th=
e
> remote.

A failed merge leaves the head of the tree to be merged in MERGE_HEAD,
so you can use "git reset --hard MERGE_HEAD" generically.

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
