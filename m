Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760575Ab3DCKEc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:04:32 -0400
Date: Wed, 3 Apr 2013 12:05:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Laurens <laurens.nikolaisen@gmx.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: =?iso-8859-1?Q?Intel?= =?iso-8859-1?Q?=AE?= PRO/Wireless 3945ABG
 seems to cause system freeze
Message-ID: <20130403100528.GB1575@redhat.com> (sfid-20130403_120436_674372_76229303)
References: <51558D37.7040508@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51558D37.7040508@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 29, 2013 at 01:46:47PM +0100, Laurens wrote:
> it seems like if the Intel 3945BG causes freezes to my computer
> system under Xubuntu 12.04.2. Though I am not very sure about it I'd
> like to ask you to go through my dmesg log. If you can point out if
> it's the wireless card which causes trouble please let me know. Also
> if you know how to fix that I would much appreciate that!
> 
> There is one log called dmesg, including the whole log, and one with
> this request:
> 
> dmesg_wifi.txt
> 
> dmesg | egrep 'net|eth|sky|sis|via|3c3|3c5|e100|8139|8169|acx|air|ath|atl|ar9|carl|atme|at7|herm|iwl|ipw|rtl8|r81|rt2|rt3|rt6|rt7|tg3|ssb|wl|b43|b44|ori|pri|p5|zd|ndis|wmi|ns8|FW'
> 
> ...called dmesg wifi.

Dmesg's do not show much, beside that you use old 3.2 kernel.
What make you think iwl3945 cause freezes on your system?
If you blacklist that module freezes do not happen ?

Stanislaw

