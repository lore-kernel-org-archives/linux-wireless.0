Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44388 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab0F3T1w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 15:27:52 -0400
Subject: Re: Compat-wireless release for 2010-06-30 is baked
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100630190300.056B742E2B@repository3.orbit-lab.org>
References: <20100630190300.056B742E2B@repository3.orbit-lab.org>
Content-Type: text/plain
Date: Wed, 30 Jun 2010 15:27:47 -0400
Message-Id: <1277926067.6591.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-30 at 15:02 -0400, Compat-wireless cronjob account
wrote:
> From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
>    4570588..85e0e99  history    -> origin/history
>  + 1b72384...7a6353a master     -> origin/master  (forced update)
>    5904b3b..984bc96  stable     -> origin/stable
>  * [new tag]         next-20100630 -> next-20100630
> cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
> cat: compat_base_tree: No such file or directory

Luis, could you please check what is going on?  There was another
announcement with error messages.  Then there was a truncated message.
Now the errors are back.

I'm not sure such messages should be posted to the list.  It would be
more useful to send then to those who can do something in the build
system breaks.

-- 
Regards,
Pavel Roskin
