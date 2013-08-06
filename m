Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16144 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3HFHDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 03:03:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Bartosz Markowski <bartosz.markowski@tieto.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: add SoC power save option to PCI features map
References: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
	<CA+BoTQkD5grL_5dJDgkwo40ET1zax56oN=ZGFxnyGqboQShbgQ@mail.gmail.com>
	<87iozkf5w0.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkCQMZaicJpcrJGk+vz7kwMgcQcLS6PUn_4c65PJ4gRTA@mail.gmail.com>
Date: Tue, 6 Aug 2013 10:03:17 +0300
In-Reply-To: <CA+BoTQkCQMZaicJpcrJGk+vz7kwMgcQcLS6PUn_4c65PJ4gRTA@mail.gmail.com>
	(Michal Kazior's message of "Tue, 6 Aug 2013 08:57:40 +0200")
Message-ID: <87iozjcnd6.fsf@kamboji.qca.qualcomm.com> (sfid-20130806_090329_346000_1B7FB20A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 5 August 2013 18:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>> But this doesn't prevent taking this patch as the race has existed since
>> the beginning, right?
>
> I don't have anything against it.

That's what I assumed as well, just wanted to be sure before I commit
the patch.

> I just noticed the race and thought it's good to point out the issue.

Yes, that was a very good find. Please continue finding more races in
the code :)

-- 
Kalle Valo
