Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757126AbYJJRbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 13:31:39 -0400
Date: Fri, 10 Oct 2008 10:31:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, zOOmER.gm@gmail.com
Subject: Re: [Bugme-new] [Bug 11728] New: 2.6.27 RTL8187b wireless driver
 missing card support 0bda:8198
Message-Id: <20081010103108.7a7a3fbf.akpm@linux-foundation.org> (sfid-20081010_193142_982461_11D78900)
In-Reply-To: <bug-11728-10286@http.bugzilla.kernel.org/>
References: <bug-11728-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Fri, 10 Oct 2008 08:29:17 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11728
> 
>            Summary: 2.6.27 RTL8187b wireless driver missing card support
>                     0bda:8198
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Network
>         AssignedTo: jgarzik@pobox.com
>         ReportedBy: zOOmER.gm@gmail.com
> 
> 
> Hardware Environment: Toshiba Satellite L300-110 laptop (with built-in USB
> wireless card RTL8187b, DEVICE ID 0bda:8198)
> 
> Problem Description:
> 2.6.27 Kernel cannot detect wireless card.
> 
> Problem goes out, if in rtl8187_dev.c file i add a line with this card DEVID:
> {USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
> After this done and recompiling module, card works fine(tested it for hours
> with WEP and without authentication)
> 

