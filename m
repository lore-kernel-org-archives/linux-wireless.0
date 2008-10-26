Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:60677 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYJZRvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 13:51:09 -0400
Received: by ey-out-2122.google.com with SMTP id 6so700234eyi.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 10:51:07 -0700 (PDT)
Message-ID: <4904AE0E.6030000@gmail.com> (sfid-20081026_185117_026079_C477145E)
Date: Sun, 26 Oct 2008 18:51:10 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: b43: Everybody with PHY TX error, please try
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WOW, no more errors, all gone. I haven't seen it in days lol =)

						Good job!


 >><<
Everybody with PHY TX error, please try updated firmware from
ftp://ftp.linksys.com/opensourcecode/wrt610n/1.00.00.018/wrt610n_v1.00.00.018_us.tgz
(Yeah, big tarball. It's 87MB)

Extract the file wrt610n_v1.00.00.018_us/release/src/wl/linux/wl.o out 
of the archive.
Get latest b43-tools:
git clone http://git.bu3sch.de/git/b43-tools.git

Build and install fwcutter from latest b43-tools.git

Extract the firmware from the wl.o file:
b43-fwcutter --unsupported -w /lib/firmware/DESTPATH  wl.o

Try to reproduce the PHY TX error with the new firmware.

Thanks.

-- 
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@...
More majordomo info at  http://vger.kernel.org/majordomo-info.html

 >><<
