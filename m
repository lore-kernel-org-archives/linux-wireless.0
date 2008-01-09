Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:24505 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYAIJHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:07:11 -0500
To: Pavel Roskin <proski@gnu.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge errors on 'everything'
References: <200801091043.02204.bruno@thinktube.com>
	<20080109015102.GB3048@tuxdriver.com> <1199845968.3697.22.camel@dv>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 09 Jan 2008 11:05:26 +0200
In-Reply-To: <1199845968.3697.22.camel@dv> (ext Pavel Roskin's message of "Tue\, 08 Jan 2008 21\:32\:48 -0500")
Message-ID: <87myrf74ix.fsf@nokia.com> (sfid-20080109_090726_167351_906F801E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

>> You'll need to get a fresh clone of the repository -- sorry.
>
> While it's reassuring to see that I'm not missing some elegant solution,
> I think cloning the repository is a major overkill.

I agree. 

> "git-reset --hard origin/everything" does the trick for me, while using
> much less bandwidth and time.

I do the same and it has worked for me, at least.

It would be nice if git would somehow do this automatically with
rebased trees. Or maybe it already supports it and I'm not just aware
of it?

-- 
Kalle Valo
