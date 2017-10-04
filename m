Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:59732 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdJDIuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 04:50:15 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        svp <s.pooheer@gmail.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: QCA988x and kernel 4.13
Date: Wed, 4 Oct 2017 08:50:10 +0000
Message-ID: <87d163xpoe.fsf@kamboji.qca.qualcomm.com> (sfid-20171004_105022_147600_9F539D43)
References: <c6294832-ff1e-595c-da8b-dac59b12a976@gmail.com>
        <7549b77b-3619-f8a5-48d6-eb7e330ba80e@dd-wrt.com>
        <48aebea8-9231-b41e-cbaa-d592d8540c53@candelatech.com>
In-Reply-To: <48aebea8-9231-b41e-cbaa-d592d8540c53@candelatech.com> (Ben
        Greear's message of "Mon, 2 Oct 2017 10:24:14 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 10/01/2017 07:06 AM, Sebastian Gottschall wrote:
>> you have to update to the latest mac80211 code. there is a well
>> known bug in mac80211 which causes a deadlock with ath10k
>
> Do you have a pointer to the patch that fixes this?  I'd like to check if=
 it has
> made it into 4.13 stable yet...

I think it's this one:

mac80211: fix deadlock in driver-managed RX BA session start

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dbde59c475e0883e4c4294bcd9b9c7e08ae18c828

Adding linux-wireless so that someone can correct me in case I'm wrong.

--=20
Kalle Valo=
