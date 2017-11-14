Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:1327 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753277AbdKNMPL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 07:15:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Daniel Drake <drake@endlessm.com>
CC: Russell Hu <rhu@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Robert Chang <rwchang@qti.qualcomm.com>,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "andy@infradead.org" <andy@infradead.org>
Subject: Re: [v2] ath9k: add MSI support
Date: Tue, 14 Nov 2017 12:15:08 +0000
Message-ID: <87bmk5hx9x.fsf@kamboji.qca.qualcomm.com> (sfid-20171114_131535_818617_5E3E22B8)
References: <20171110025415.7854-1-drake@endlessm.com>
        <87y3na7eei.fsf@qca.qualcomm.com>
        <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com>
In-Reply-To: <CAD8Lp47uJbB27xZPH3dDqNuJcaNCGEsbpdqfK-h4+nzVLGk1aw@mail.gmail.com>       (Daniel
 Drake's message of "Tue, 14 Nov 2017 06:36:36 +0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake <drake@endlessm.com> writes:

> On Mon, Nov 13, 2017 at 4:48 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrot=
e:
>> Enabling MSI by default is just too invasive, ath9k is used in so many
>> different enviroments that risk of regressions is high. MSI needs a lot
>> of testing before we can even consider enabling it by default.
>
> And it seems like we already found a regression here - the MSI Message
> Data is being corrupted as described in my last mail.

Exactly.

> Can't be fixed in firmware, but it would be good to have confirmation
> of the hardware behavivour, and maybe some other solution is possible?
> Are you following this up within Qualcomm?

No time to do that right now, sorry.

--=20
Kalle Valo=
