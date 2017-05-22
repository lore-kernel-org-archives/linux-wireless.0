Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56889 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934523AbdEVOXD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 10:23:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Maya Haim <merez@qti.qualcomm.com>
CC: qca_merez <qca_merez@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>,
        qca_liord <qca_liord@qca.qualcomm.com>
Subject: Re: [PATCH v2 4/5] wil6210: add option to ignore OTA regulatory hints
Date: Mon, 22 May 2017 14:22:57 +0000
Message-ID: <871srhug1z.fsf@kamboji.qca.qualcomm.com> (sfid-20170522_162434_078153_5478F7C4)
References: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1494848759-3651-5-git-send-email-qca_merez@qca.qualcomm.com>
        <8737c1a1h6.fsf@qca.qualcomm.com>
        <71d0595982f24c12b519fa67ea6f0ad8@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <71d0595982f24c12b519fa67ea6f0ad8@euamsexm01a.eu.qualcomm.com>
        (Maya Haim's message of "Sun, 21 May 2017 20:07:32 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Haim <merez@qti.qualcomm.com> writes:

> kvalo@qca.qualcomm.com wrote:
>>=20
>> I wonder should something like this be in cfg80211? Because I doubt
>> wil6210 is the only driver having this problem.
>
> We will check that and share our conclusions.
> Can you please drop this patch for now and apply the rest of the patches
> (if there are no additional comments)?

Sure, I have now dropped this patch. The rest are still on my queue.

--=20
Kalle Valo=
