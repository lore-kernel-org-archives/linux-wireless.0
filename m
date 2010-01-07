Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45733 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab0AGUW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 15:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <2d0a357f1001071214m6780def8md80c056161d0aa79@mail.gmail.com>
References: <8db1092f1001071136o20ac7e19nb102c7afde8c21e7@mail.gmail.com>
	 <2d0a357f1001071214m6780def8md80c056161d0aa79@mail.gmail.com>
Date: Thu, 7 Jan 2010 21:22:53 +0100
Message-ID: <8db1092f1001071222i1844e559g75e6067faf05fb63@mail.gmail.com>
Subject: Re: [2.6.33-rc3] [WMI?] [RFKILL?] [WIRELESS?] hang: BUG: Unable to
	handle kernel NULL pointer dereference at 00000008
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: sedat.dilek@gmail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	carlos@strangeworlds.co.uk,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, ilw@linux.intel.com,
	len.brown@intel.com, Anisse Astier <anisse@astier.eu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/7 Sedat Dilek <sedat.dilek@googlemail.com>:
> Hi,
>
> seems like the ACPI/hp-wmi bug, nothing to do with linux-wireless.
>
> I have already reported this bug (again) [1] and unfortunately it has
> re-entered upstream.
> A single new patch was sent by Anisse [2].
> This patch is waiting in linux-acpi-2.6/test [3].
>
> Don't ask me why it has not been included in 2.6.33-rc3.
> For some HP-notebook users it is a CRITICAL bug.
>
> Kind Regards,
> - Sedat -
>
> [1] http://marc.info/?t=126227644600001&r=1&w=2
> [2] http://marc.info/?t=126215864800004&r=1&w=2
> [3] http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=c9c041fcb1a4d69ed4791f00b57554eeb341d148
>



Thanks for the answer.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
