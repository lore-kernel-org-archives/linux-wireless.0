Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:63301 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbZJHUYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 16:24:18 -0400
Received: by bwz6 with SMTP id 6so1129293bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 08 Oct 2009 13:23:40 -0700 (PDT)
Message-ID: <4ACE4A48.9070901@lwfinger.net>
Date: Thu, 08 Oct 2009 15:23:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net> <20091007190106.GB22394@tuxdriver.com>
In-Reply-To: <20091007190106.GB22394@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2009 02:01 PM, John W. Linville wrote:
> OK, but why do we start polling under the lock but stop polling without
> the lock?  Should we start polling without holding the lock too?

I see that this patch was committed. I hope that you will be sending 
it upstream for 2.6.32. The correct version has been sent to stable 
for inclusion in 2.6.31, but as usual, a mainline commit ID will be 
needed.

Larry
