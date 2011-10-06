Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39419 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab1JFT2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:28:54 -0400
Received: by qyk7 with SMTP id 7so2996249qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:28:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111006190442.53FBF40650@repository3.orbit-lab.org>
References: <20111006190442.53FBF40650@repository3.orbit-lab.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 6 Oct 2011 12:28:33 -0700
Message-ID: <CAB=NE6UMU-BC4J39=JLuPGsCT=BXr0B2c-XxG2Tgu4NxWVzxhg@mail.gmail.com> (sfid-20111006_212907_311055_9BDC1D7F)
Subject: Re: Compat-wireless release for 2011-10-06 is baked
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 12:04 PM, Compat-wireless cronjob account
<compat@orbit-lab.org> wrote:
> From git://github.com/mcgrof/compat-wireless
>   2309ddb..e4f1a17  master     -> origin/master
> From git://github.com/mcgrof/compat
>   966e847..b5edac3  master     -> origin/master
> From git://github.com/sfrothwell/linux-next
>  + a2851f2...98b3e8f akpm-end   -> origin/akpm-end  (forced update)
>   a8062e4..538d288  akpm-start -> origin/akpm-start
>  + 09d70e2...40a33ae master     -> origin/master  (forced update)
>   a8062e4..538d288  stable     -> origin/stable
>  * [new tag]         next-20111006 -> next-20111006
> From git://github.com/sfrothwell/linux-next
>  * [new tag]         v3.1-rc9   -> v3.1-rc9
>
> compat-wireless code metrics
>
>    811845 - Total upstream lines of code being pulled
>      2413 - backport code changes
>      2097 - backport code additions
>       316 - backport code deletions
>      8588 - backport from compat module
>     11001 - total backport code
>    1.3551 - % of code consists of backport work
> Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
> rsync: connection unexpectedly closed (0 bytes received so far) [sender]
> rsync error: unexplained error (code 255) at io.c(601) [sender=3.0.7]

Fixed.

  Luis
