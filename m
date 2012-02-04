Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33808 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2BDKa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 05:30:29 -0500
Received: by vcge1 with SMTP id e1so3115965vcg.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Feb 2012 02:30:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120203060424.GB15811@vmraj-lnx.users.atheros.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
	<20265.65072.546108.448327@gargle.gargle.HOWL>
	<20120202035652.GB25988@vmraj-lnx.users.atheros.com>
	<20266.3200.403302.486325@gargle.gargle.HOWL>
	<CAJ-VmomK0cD5rYbSYOQ7xwJLADdbD=a4JVG1bcd4QdTpV+uN2Q@mail.gmail.com>
	<20120203060424.GB15811@vmraj-lnx.users.atheros.com>
Date: Sat, 4 Feb 2012 02:30:26 -0800
Message-ID: <CAJ-VmokNu1VNY5DBeaUeHx=yJZ8vMpXbA_AwDrfxKDySObHvDw@mail.gmail.com> (sfid-20120204_113032_296005_1C75A912)
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
From: Adrian Chadd <adrian@freebsd.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 February 2012 22:04, Rajkumar Manoharan <rmanohar@qca.qualcomm.com> wrote:
>> > Ok. But this stuff really needs to be verified for other chips.
>> > These 'poll' workarounds are piling up.
>> >
>>
>> Hi,
>>
>> Is there a bugzilla.kernel.org bug for this particular behaviour? And if
>> you can dig up the internal bug number, please  post it privately.
>>
> No. This issue was originally reported by Google in their setup.

Can we please ensure that a bugzilla.kernel.org bug report is created,
at the very least?

Thanks,


Adrian
