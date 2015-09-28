Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55145 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbbI1SOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 14:14:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Pending patches in patchwork and their states
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
	<56097D6D.1010509@broadcom.com>
Date: Mon, 28 Sep 2015 21:14:45 +0300
In-Reply-To: <56097D6D.1010509@broadcom.com> (Arend van Spriel's message of
	"Mon, 28 Sep 2015 19:48:29 +0200")
Message-ID: <8737xy9zsa.fsf_-_@kamboji.qca.qualcomm.com> (sfid-20150928_201456_943772_B28908AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> If my administration is correct there are 29 patches pending. Any
> chance these will get applied. Or did I miss some remarks requiring a
> resend.

Yeah, I have been lagging behind patches due to other stuff and I have
64 patches pending right now. Sorry about that, I should get to them in
a day or two. Here's a short summary how I use patchwork. Hopefully it
makes it easier for people to follow their patch status and I get less
emails ;)

If the patch in patchwork is in state New or Under Review they are on my
queue and waiting my action:

https://patchwork.kernel.org/project/linux-wireless/list/

If the patch is Deferred it means that there was a problem and I look at
the patch more closely later (when I have more time etc):

https://patchwork.kernel.org/project/linux-wireless/list/?state=10

Awaiting Upstream means that I cannot apply the patch right now due to a
mising patch in some other component, for example to mac80211. I will
apply the patch once the dependency is available in my tree:

https://patchwork.kernel.org/project/linux-wireless/list/?state=8

Any other state means that the patch is out of my radar due to one
reason or another, and a resend is needed to get the patch active again:

Rejected = In my opinion not acceptable patch
RFC = Request For Comments, submitter didn't officially send the patch yet
Not Applicaple = Not a wireless patch
Changes Requested = Needs a new version due to review comments
Superseded = A new version of the patch submitted without comments

And Accepted state of course means that I have commited the patch :)

-- 
Kalle Valo
