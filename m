Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49424 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab1EFFt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 01:49:28 -0400
Received: by wwa36 with SMTP id 36so3140309wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 22:49:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DC386BB.4010106@lockie.ca>
References: <4DC386BB.4010106@lockie.ca>
Date: Fri, 6 May 2011 11:19:27 +0530
Message-ID: <BANLkTinc_raEdwm-uxSKWHBMoB92V5fxgw@mail.gmail.com> (sfid-20110506_074932_428648_089BF578)
Subject: Re: scan not working or limited
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 6, 2011 at 10:57 AM, James <bjlockie@lockie.ca> wrote:
>
> I get the errors:
> ath: Failed to stop TX DMA in 100 msec after killing last frame
> ath: Failed to stop TX DMA!
> on all the kernels that my scans don't work right.
>
> I did:
> $ git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.git
> $ cd linux-2.6.37.y
> $ git bisect start
> $ git bisect good v2.6.36
> $ git bisect bad v2.6.37.6
> It said 3044100e58c84e133791c8b60a2f5bef69d732e4 is the first bad commit.
>
> I typed that number. :-(
> How do I make git print it again?
> How do I find the details of that commit?

git show 3044100e58c84e133791c8b60a2f5bef69d732e4

> How do I reverse what that commit did?

git revert 3044100e58c84e133791c8b60a2f5bef69d732e4

but that commit is not related to the problem you have

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
