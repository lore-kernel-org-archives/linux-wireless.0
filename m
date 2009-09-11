Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29303 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbZIKEdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 00:33:03 -0400
Message-ID: <20090911003705.n9vun04fks8480wk-cebfxv@webmail.spamcop.net>
Date: Fri, 11 Sep 2009 00:37:05 -0400
From: Pavel Roskin <proski@gnu.org>
To: John Ranson <ranson@analager.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Differences between wireless-testing and mainline
References: <bcd1ba70909101959u4581537ci684a2c45bc17c965@mail.gmail.com>
In-Reply-To: <bcd1ba70909101959u4581537ci684a2c45bc17c965@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting John Ranson <ranson@analager.net>:

> Is there a good way to keep track of the differences between the
> mainline kernel and wireless testing?  I'm running wireless testing to
> minimize firmware errors with my iwl4965 card. When mainline
> incorporates the code that I'm running, I would like to switch back.

git whatchanged wireless-testing/base..wireless-testing/master

wireless-testing/base is usually the latest release or release  
candidate from the mainline.

If you want a better granularity, e.g. you are ready to switch to the  
mainline before rc1, you'll need to track the mainline and look for  
the patches you care about.

You can also pick up the patches you need from wireless-testing and  
apply them to the mainline repository.  If you do it with STGit, it  
will tell you that the patches have been merged by telling you that  
the local patches have become empty after the update.

-- 
Regards,
Pavel Roskin
