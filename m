Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40134 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaHKRwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 13:52:32 -0400
Received: by mail-qc0-f181.google.com with SMTP id x13so1883865qcv.40
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 10:52:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bug-82121-41252@https.bugzilla.kernel.org/>
References: <bug-82121-41252@https.bugzilla.kernel.org/>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Aug 2014 11:52:11 -0600
Message-ID: <CAErSpo4SSeaNJ4RLVVA9wJjsFdUs+0ktXBrFRTsQEi9m=R7fkA@mail.gmail.com> (sfid-20140811_195241_956252_91AD5A64)
Subject: Re: [Bug 82121] New: Network controller: Intel Corporation Wireless
 3160 (rev 83) experiences low signal and poor performance
To: bugzilla-daemon@bugzilla.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+cc iwlwifi maintainers, lists]

On Sun, Aug 10, 2014 at 4:34 PM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=82121
>
>             Bug ID: 82121
>            Summary: Network controller: Intel Corporation Wireless 3160
>                     (rev 83) experiences low signal and poor performance
> ...

> I had Ubuntu 13.10 with (3.11.0-12.19) and the card worked fine. Upon upgrading
> to 14.04 the card had extremely low signal strength. If I was close enough to
> the router to make a connection it also had poor performance and wood get
> kicked off intermittently. I then installed arch and experienced the same
> problem on all of the kernel versions mentioned in the kernel version section.
> Thank you to who ever looks into this. This is my first post in this community.
> So hi!

Thanks for the report.  This device uses the iwlwifi driver, and the
issue is likely with that driver, not with the PCI core, so I'm going
to reassign the bug accordingly and copy the iwlwifi maintainers.
