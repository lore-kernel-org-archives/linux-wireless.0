Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35303 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaAMK4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 05:56:30 -0500
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com [209.85.220.53])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 1C2CD8812E
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 18:56:30 +0800 (CST)
Received: by mail-pa0-f53.google.com with SMTP id hz1so7469213pad.40
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 02:56:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D3C43A@HASMSX103.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB303D3C2B9@HASMSX103.ger.corp.intel.com>
 <CALkVjQaW0HssouGrmTYygF6mykQy0Tqs=gj5p1AOwq=iB69DbQ@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303D3C43A@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Mon, 13 Jan 2014 18:56:14 +0800
Message-ID: <CALkVjQZ-qOtv_=tJEC5rJsqNuKT1+=4QufvCu2JTpf=GH4O2UA@mail.gmail.com> (sfid-20140113_115634_499024_02BD8350)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/13 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> Are you using Bluetooth at the same time?

No, I disabled bluetooth in BIOS since Nov 2013. Never have used it.

> Also - it might be worth to try wireless-testing and the latest firmware.
> While you seem to be the first to report issues about power save on this firmware, we know that a lot of issues have been fixed in the latest firmware (-8.ucode) which is supported in 3.13 only. But if you change kernel, go for wireless-testing.
> Thanks.

Okay, I'll put this down and follow up when Linux 3.13 goes stable.

Thanks.

-- 
wzyboy
