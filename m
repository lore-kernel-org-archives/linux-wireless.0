Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:37374 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753224Ab3IEE5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 00:57:08 -0400
Message-ID: <1378357025.1787.79.camel@joe-AO722> (sfid-20130905_065712_803088_96994CD1)
Subject: Re: [PATCH 2/2] qca-swiss-army-knife: add ath10k trace-cmd plugin
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 04 Sep 2013 21:57:05 -0700
In-Reply-To: <871u53swie.fsf@kamboji.qca.qualcomm.com>
References: <1376939466-8282-1-git-send-email-kvalo@qca.qualcomm.com>
	 <1376939466-8282-2-git-send-email-kvalo@qca.qualcomm.com>
	 <CAB=NE6UCmO4QbFjtav8xPDAoebpTqDNwz_qQxg1TQ8cKGcbFGg@mail.gmail.com>
	 <871u53swie.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-09-05 at 07:49 +0300, Kalle Valo wrote:
> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:
> > I just removed 3 trailing spaces on the 2 patches. One had two
> > trailing spaces, the last patch had one.
> 
> Oh, sorry about that. Any ideas how I could check for those myself?

scripts/checkpatch.pl <patch>
git am <patch>


