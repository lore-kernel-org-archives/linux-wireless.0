Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35518 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab3KFHM5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 02:12:57 -0500
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com [209.85.220.50])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 98D638813A
	for <linux-wireless@vger.kernel.org>; Wed,  6 Nov 2013 15:12:56 +0800 (CST)
Received: by mail-pa0-f50.google.com with SMTP id fb1so10128860pad.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 23:12:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
References: <5276134B.8070808@wzyboy.org> <0BA3FCBA62E2DC44AF3030971E174FB301DE75AE@HASMSX103.ger.corp.intel.com>
 <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com>
 <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
 <CALkVjQaLx2spaOqUPcs_EwMkU7npMki1Reo1MeZwxB7m=c24=g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE9FC6@HASMSX103.ger.corp.intel.com>
 <CALkVjQZDNSgUUFyi94Y8da_NDzW61rCvaMrZpUugFKW_LRNFFA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CALkVjQZRJw7ghjBa1aPKNKe3Zj2B1Mhk5bWVaRdcCYzfoLRovg@mail.gmail.com>
 <CALkVjQY7r=YKhsgDKR0mnYVtZy5BAdj83nY2jL0VFaiew6ha7A@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Wed, 6 Nov 2013 15:12:40 +0800
Message-ID: <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com> (sfid-20131106_081259_708786_ECF3CF06)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/6 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> Wait - you mean that after the bug occurred before you rebooted, lspci -xxx show all 00?
> I can see 0xff here.
> Anyway - this is very bad... checking with HW guys...


Sorry, that's my typo. They are all 0xff... (I don't know what do they
mean but it look bad...)

Thanks for your effort! I'm waiting for good news from you and HW guys. :-)

-- 
wzyboy
