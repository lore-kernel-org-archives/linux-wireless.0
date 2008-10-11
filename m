Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53688 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbYJKSSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 14:18:52 -0400
Message-ID: <48F0EE06.4020803@lwfinger.net> (sfid-20081011_201856_360337_97899DAB)
Date: Sat, 11 Oct 2008 11:18:46 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	zOOmER.gm@gmail.com
Subject: Re: [Bugme-new] [Bug 11728] New: 2.6.27 RTL8187b wireless driver
 missing card support 0bda:8198
References: <bug-11728-10286@http.bugzilla.kernel.org/> <20081010103108.7a7a3fbf.akpm@linux-foundation.org> <20081010181841.GA20509@tuxdriver.com>
In-Reply-To: <20081010181841.GA20509@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, Oct 10, 2008 at 10:31:08AM -0700, Andrew Morton wrote:
>> (switched to email.  Please respond via emailed reply-to-all, not via the
>> bugzilla web interface).
>>
>> On Fri, 10 Oct 2008 08:29:17 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=11728
>>>
>>>            Summary: 2.6.27 RTL8187b wireless driver missing card support
>>>                     0bda:8198
>>>            Product: Drivers
>>>            Version: 2.5
>>>      KernelVersion: 2.6.27
>>>           Platform: All
>>>         OS/Version: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: Network
>>>         AssignedTo: jgarzik@pobox.com
>>>         ReportedBy: zOOmER.gm@gmail.com
>>>
>>>
>>> Hardware Environment: Toshiba Satellite L300-110 laptop (with built-in USB
>>> wireless card RTL8187b, DEVICE ID 0bda:8198)
>>>
>>> Problem Description:
>>> 2.6.27 Kernel cannot detect wireless card.
>>>
>>> Problem goes out, if in rtl8187_dev.c file i add a line with this card DEVID:
>>> {USB_DEVICE(0x0bda, 0x8198), .driver_info = DEVICE_RTL8187B},
>>> After this done and recompiling module, card works fine(tested it for hours
>>> with WEP and without authentication)
>>>
>  
> From: John W. Linville <linville@tuxdriver.com>
> Subject: [PATCH] rtl8187: add device ID 0bda:8198
> 
> Reported by zOOmER.gm@gmail.com to work here:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=11728
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
ACK

Larry

