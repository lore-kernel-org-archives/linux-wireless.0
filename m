Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173017pub.verizon.net ([206.46.173.17]:36114 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2CKT54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 15:57:56 -0400
Received: from vms170029 ([unknown] [192.168.1.3]) by vms173017.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0Q00AXOKSHLJ80@vms173017.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sun, 11 Mar 2012 14:57:53 -0500 (CDT)
Date: Sun, 11 Mar 2012 14:57:53 -0500 (CDT)
From: alupu@verizon.net
To: linux-wireless@vger.kernel.org
Message-id: <13558318.560745.1331495873638.JavaMail.root@vms170029> (sfid-20120311_205827_784603_3B52E03C)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/12 11:23 PM, Larry Finger wrote:

> I have a Rosewill RNX-N180UBE. The chip is a RTL8191RU, but appears to be 
> programmed the same as the RTL8191SU. Mine works with the standard r8712u driver.

In WinXP, the driver is identified as 'RTL8192su.sys', so
for the heck of it, I enabled two additional modules,
RTL8192U and RTL8192E.
Not surprisingly, Rosewill wants to work with r8712u only.

> The two possible firmware files have the following md5sum:
> 200fd952db3cc9259b1fd05e3e51966f /lib/firmware/rtlwifi/rtl8712u.bin_122328
> 8e6396b5844a3e279ae8679555dec3f0 /lib/firmware/rtlwifi/rtl8712u.bin_129304

Both check out OK.

> Could you please download a Live KDE CD from ...

Working on that.

Thanks,
-- Alex
