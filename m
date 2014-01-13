Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35286 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaAMJGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 04:06:09 -0500
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com [209.85.192.179])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 9210A880D9
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 17:06:08 +0800 (CST)
Received: by mail-pd0-f179.google.com with SMTP id y10so168977pdj.38
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 01:06:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D3C2B9@HASMSX103.ger.corp.intel.com>
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
 <0BA3FCBA62E2DC44AF3030971E174FB303D2D2C5@HASMSX103.ger.corp.intel.com>
 <CALkVjQaWBq6--sekifyGfJt9FDigsk56eXMUv9YR3sDVnVcX=Q@mail.gmail.com>
 <CAErSpo4ZxJ8T8ih1+svqjpUNbJo-WezP=9OatDTuLk3u=zkCLw@mail.gmail.com>
 <CALkVjQbjnAk0mFZ-3zjx_15xXEaaiMaVxMMLD1HEUJhVtYXg4g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C00A@HASMSX103.ger.corp.intel.com>
 <CALkVjQZ9Tc7Xx9ANzcp_4_7_=BCLM7EHS+oJUxQ57QXuSiv+YA@mail.gmail.com>
 <CALkVjQavGvumxnghCc5R8E=7rzDSy1_q+LVZ=vR6--OJxhp7CA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C1CB@HASMSX103.ger.corp.intel.com>
 <CALkVjQYSHb-dYckxeq2t4yj3DY8n=j-RrtrB53+ddJstS_qXUw@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303D3C2B9@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Mon, 13 Jan 2014 17:05:53 +0800
Message-ID: <CALkVjQaW0HssouGrmTYygF6mykQy0Tqs=gj5p1AOwq=iB69DbQ@mail.gmail.com> (sfid-20140113_100615_514686_37CCDADA)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/13 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> What kernel version :)
> If you use 3.13, you can try a newer firmware.
>

I applied your patch against Arch Linux's stock kernel 3.12.7, using
this PKGBUILD: https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/linux&id=5e2f3b10dc4be40da8f1fe355bc871d7936ec2d8

wzyboy@xenien:~$ uname -a
Linux xenien.wzyboy.im 3.12.7-1-ARCH #1 SMP PREEMPT Sun Jan 12
20:38:55 CST 2014 x86_64 GNU/Linux
wzyboy@xenien:~$ cat /proc/version
Linux version 3.12.7-1-ARCH (wzyboy@xenien.wzyboy.im) (gcc version
4.8.2 20131219 (prerelease) (GCC) ) #1 SMP PREEMPT Sun Jan 12 20:38:55
CST 2014



-- 
wzyboy
