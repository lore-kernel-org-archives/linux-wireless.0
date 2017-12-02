Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:19527 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751747AbdLBOeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 09:34:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: Re: [v3] ath10k: rebuild crypto header in rx data frames
Date: Sat, 2 Dec 2017 14:34:00 +0000
Message-ID: <878telw65j.fsf@kamboji.qca.qualcomm.com> (sfid-20171202_153413_894121_61FAE6F3)
References: <1509035774-26553-1-git-send-email-kvalo@qca.qualcomm.com>
        <59b2ec22dc9c4db0bd30a65dba660b1c@euamsexm01a.eu.qualcomm.com>
        <154f13b8-1e77-dbe5-4cb0-81c534dbc40b@dd-wrt.com>
        <e98b52a7-ac14-81da-1fab-0c66befcf6d2@candelatech.com>
In-Reply-To: <e98b52a7-ac14-81da-1fab-0c66befcf6d2@candelatech.com> (Ben
        Greear's message of "Tue, 21 Nov 2017 10:54:03 -0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> Is this patch destined for stable?
>
> I was expecting to see it show up in the older stable releases,
> but it has not so far as far as I can tell.

We are working on it, but not sure yet to which releases, it doesn't
directly apply to all active stable releases.

--=20
Kalle Valo=
