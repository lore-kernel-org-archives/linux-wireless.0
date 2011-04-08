Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34805 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab1DHOyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 10:54:00 -0400
Message-ID: <4D9F2185.10108@lwfinger.net>
Date: Fri, 08 Apr 2011 09:53:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Removal of staging/rt2860sta (and rt2870sta)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

When I looked again at the removal of rt2860sta from staging, it was quickly 
obvious that unless rt2870sta was also removed, very little of the code could be 
removed. As I have no experience with rt2800usb, the mainline driver for that 
device, I went to the wireless mailing list with the question. There was one 
objection to the removal, but the maintainers were in favor, thus I will be 
submitting a patch to delete both drivers.

I did the changes on my local git tree, committed them, and used 'git 
format-patch'. I expected that 'git rm' statements would be used to delete the 
files, but I got normal patch format. As a result, the resulting patch is over 
2.4 GB, and has over 75,000 lines. Obviously, I'm reluctant to dump a patch of 
this size on the lists. Is there a way to force git to use "rm" statements, or 
is there some way to handle this large patch?

Thanks,

Larry


