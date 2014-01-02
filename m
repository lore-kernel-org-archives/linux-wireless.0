Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38472 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaABVeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 16:34:37 -0500
Received: by mail-ig0-f182.google.com with SMTP id c10so34711697igq.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 13:34:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALkVjQaWBq6--sekifyGfJt9FDigsk56eXMUv9YR3sDVnVcX=Q@mail.gmail.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com> <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
 <CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com>
 <CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com>
 <CALkVjQZdPuE2F+ZARBLha-+iOMA4AjDWHO4=ssnuF2Uu87RyuQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02EC1@HASMSX103.ger.corp.intel.com>
 <CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com>
 <CAErSpo6bKOpycD=cp08aBqp2U-u7sdbTSBYoHop1-1Hkmr3F-g@mail.gmail.com>
 <CALkVjQaOHix5uxFGd-62negbfubz-rdP+zmj9w5wDEa1rCA75Q@mail.gmail.com>
 <5285E028.20906@gmail.com> <CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com>
 <CANUX_P1j9QNGQ2n02KpXsuMQcZo9uOsSN-zZ8yNS1e5+Y9bJOA@mail.gmail.com>
 <CALkVjQYFJzP1E_YayPOjRu3u85WdpDojDD+DmU9ZehY7ZHF0AA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D297F0@HASMSX103.ger.corp.intel.com>
 <CALkVjQaJ94osfBwnrpKBk4tE_+=XMqznXY=qVv5KdzSkvsthaA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D2D2C5@HASMSX103.ger.corp.intel.com> <CALkVjQaWBq6--sekifyGfJt9FDigsk56eXMUv9YR3sDVnVcX=Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 2 Jan 2014 14:34:17 -0700
Message-ID: <CAErSpo4ZxJ8T8ih1+svqjpUNbJo-WezP=9OatDTuLk3u=zkCLw@mail.gmail.com> (sfid-20140102_223443_446582_20C4393D)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: wzyboy <wzyboy@wzyboy.org>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"Bj?rn Mork" <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 29, 2013 at 2:23 AM, wzyboy <wzyboy@wzyboy.org> wrote:
> 2013/12/29 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
>> http://rweverything.com/
>
>
> Here are the output of "PCI" and "PCI Index" of Intel Wireless.

ASPM must be configured on both ends of the link, so for completeness,
can you also collect the "PCI" output for the bridge leading to the
7260 device?  Based on the Linux lspci output, this should be
0000:00:1c.1.

And I assume the device works well with the Windows driver?

Bjorn
