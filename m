Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10774 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcDENCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 09:02:48 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Fix deadlock when peer cannot be created.
Date: Tue, 5 Apr 2016 13:02:43 +0000
Message-ID: <87k2kcb43y.fsf@kamboji.qca.qualcomm.com> (sfid-20160405_150252_159035_27DD71EA)
References: <1459379297-21496-1-git-send-email-greearb@candelatech.com>
	<CAGRGNgWEua3EOePQFRS_AR5BnSUPUhFrudWs2hY7YPLizxnyhQ@mail.gmail.com>
In-Reply-To: <CAGRGNgWEua3EOePQFRS_AR5BnSUPUhFrudWs2hY7YPLizxnyhQ@mail.gmail.com>	(Julian
 Calaby's message of "Thu, 31 Mar 2016 12:41:54 +1100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

> On Thu, Mar 31, 2016 at 10:08 AM,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> We must not attempt to send WMI packets while dholding the data-lock,
>
> s/dholding/holding/ ?

I fixed it in the pending branch.

-- 
Kalle Valo