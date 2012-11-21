Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4762 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab2KUKbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 05:31:18 -0500
Message-ID: <50ACAD4F.1050704@broadcom.com> (sfid-20121121_113126_043935_E7F6F5D6)
Date: Wed, 21 Nov 2012 11:30:39 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Mario De Chenno" <mario@dechenno.eu>
cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: brcmsmac crash/disconects
References: <CANZhVKPJTapzHbu4iY_uC+uuwpn1XqraR6wpC8dn9+yNC55m1Q@mail.gmail.com>
 <50AB2DEF.9040602@broadcom.com>
 <CANZhVKPGZK_g+bF0TJUPoJ_-dQKFCn4kwAmcJb_XmqDTnunw_g@mail.gmail.com>
In-Reply-To: <CANZhVKPGZK_g+bF0TJUPoJ_-dQKFCn4kwAmcJb_XmqDTnunw_g@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/12 23:30, Mario De Chenno wrote:
> Here I am.
> I attach some more logs. I also applied the patch, ran make install
> and reboot (twice), but /sys/kernel/debug is empty.
> Maybe do I miss a dependency? You can also take a look at my kernel's .config.
> Let me know,
> Mario
> 
Hi,

thanks for detailed info,
you need to be root to see contents of /sys/kernel/debug

Kind regards
Piotr

