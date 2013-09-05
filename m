Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:44914 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753545Ab3IEFi5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 01:38:57 -0400
Message-ID: <1378359531.1944.3.camel@joe-AO722> (sfid-20130905_073913_384330_A7FED0B8)
Subject: Re: [PATCH 2/2] qca-swiss-army-knife: add ath10k trace-cmd plugin
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Sep 2013 22:38:51 -0700
In-Reply-To: <87sixjrhan.fsf@kamboji.qca.qualcomm.com>
References: <1376939466-8282-1-git-send-email-kvalo@qca.qualcomm.com>
	 <1376939466-8282-2-git-send-email-kvalo@qca.qualcomm.com>
	 <CAB=NE6UCmO4QbFjtav8xPDAoebpTqDNwz_qQxg1TQ8cKGcbFGg@mail.gmail.com>
	 <871u53swie.fsf@kamboji.qca.qualcomm.com>
	 <1378357025.1787.79.camel@joe-AO722>
	 <87sixjrhan.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-05 at 08:03 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Thu, 2013-09-05 at 07:49 +0300, Kalle Valo wrote:
> >> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:
> >> > I just removed 3 trailing spaces on the 2 patches. One had two
> >> > trailing spaces, the last patch had one.
> >> 
> >> Oh, sorry about that. Any ideas how I could check for those myself?
> >
> > scripts/checkpatch.pl <patch>
> 
> Checkpatch works also with trace-cmd plugins written in python?

Don't see why not.

Trailing spaces are trailing spaces and the trailing
space test is done way before looking at file type
specific tests.

> > git am <patch>
> 
> Yeah, I guess I could do that, it's just a bit inconvienient.

scripting a git am script for a patch
set is just a for loop...

You could also use scripts/cleanpatch

