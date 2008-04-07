Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54114 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbYDGB0l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2008 21:26:41 -0400
Subject: Re: [PATCH RFT] b43: We need lots of regression testing
From: Pavel Roskin <proski@gnu.org>
To: ronald645@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47F8887F.3050500@gmail.com>
References: <47F8887F.3050500@gmail.com>
Content-Type: text/plain
Date: Sun, 06 Apr 2008 21:26:39 -0400
Message-Id: <1207531599.8725.4.camel@dv> (sfid-20080407_022654_445207_1D144988)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-04-06 at 10:23 +0200, Ronald wrote:
> hey all,
> 
> Can I safely apply this patch to the 2.6.25.1 kernel once it is 
> released? I would love to test it... =)
> 
> (maybe a stupid question but I have no idea)

The patch doesn't apply cleanly to the current main branch (linux-2.6),
and it's not likely to change before 2.6.25.1.

The conflicts are minor, but the patch would need to be adjusted.

If you want to test the patch, I suggest that you don't wait, but take
the current compat-wireless instead, patch it and compile it for you
current kernel.  It worked for me.

-- 
Regards,
Pavel Roskin
