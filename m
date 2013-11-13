Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:39470 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab3KMMdz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 07:33:55 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301E002F0@HASMSX103.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com>
 <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com>
 <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com>
 <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com>
 <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com>
 <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com>
 <20131111224439.GA30638@google.com> <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com>
 <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com>
 <CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DF0865@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com> <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E00262@HASMSX103.ger.corp.intel.com>
 <CALkVjQZfc3SHv8j1Kp-N1_+nQ5_WUsk6mf1BBG9MikzkaHZECA@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301E002F0@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Wed, 13 Nov 2013 20:33:39 +0800
Message-ID: <CALkVjQbGtXYG=ETs0aNstdma68FgRAVQ0MXUZ6_eQ_oMb+widg@mail.gmail.com> (sfid-20131113_133359_776014_8F6FCF39)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/13 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>> Unsafe means battery blows up like a Samsung? :-)
>>
>
> You already blew your warranty the minute your installed Linux, didn't you? :)
>

Indeed. :-)

>> My laptop is now connected to classroom's WiFi (with setpci
>> workaround) and running on battery, it seems the power consumption is
>> acceptable ... at least not too much more than before.
>
> Cool - we work for nothing - encouraging :)

To be frank I really know little about hardware (i.e. I had never
heard of "L1" "ASPM" and other HW terms before you talked about it...)
but I'll keep an eye, see if "setpci" workaround (this disables L1 /
ASPM?) has any side effects. (I hope not)

-- 
wzyboy
