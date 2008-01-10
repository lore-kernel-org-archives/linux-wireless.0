Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39132 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbYAJKCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 05:02:48 -0500
To: bruno randolf <bruno@thinktube.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge errors on 'everything'
References: <200801091043.02204.bruno@thinktube.com>
	<1199845968.3697.22.camel@dv> <87myrf74ix.fsf@nokia.com>
	<200801101029.44985.bruno@thinktube.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 10 Jan 2008 12:00:51 +0200
In-Reply-To: <200801101029.44985.bruno@thinktube.com> (ext bruno randolf's message of "Thu\, 10 Jan 2008 10\:29\:44 +0900")
Message-ID: <873at6vw30.fsf@nokia.com> (sfid-20080110_100307_872388_2A0CF005)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bruno randolf <bruno@thinktube.com> writes:

>> > "git-reset --hard origin/everything" does the trick for me, while using
>> > much less bandwidth and time.
>>
>> I do the same and it has worked for me, at least.
>
> thanks for that hint, but still, that sucks if you want to rebase your local 
> work against an updated 'everything'...
>
> how do you guys manage your pending patches and local work then?

What I have done is that I follow upstream development in master
branch and create separate branch for my stuff. And after master
changes I'll do 'git rebase master' on my branch.

But as Andreas already mentioned, stgit is the better way to do this.

-- 
Kalle Valo
