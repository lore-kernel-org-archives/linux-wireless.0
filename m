Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41973 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab0GHTRc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 15:17:32 -0400
Received: by pwi5 with SMTP id 5so446698pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jul 2010 12:17:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100708190302.0577F42E2D@repository3.orbit-lab.org>
References: <20100708190302.0577F42E2D@repository3.orbit-lab.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 8 Jul 2010 12:17:12 -0700
Message-ID: <AANLkTikhTHFQw9OPaoVfeWywzZXefWL_kiPmsP2IgZLz@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-07-08 is baked
To: Compat-wireless cronjob account <compat@orbit-lab.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm fixing this right now, sorry for the delay.

  Luis

On Thu, Jul 8, 2010 at 12:03 PM, Compat-wireless cronjob account
<compat@orbit-lab.org> wrote:
> From git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6
>   8a97897..12f89ed  master     -> origin/master
> From git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next
>   b396362..59d8d6f  history    -> origin/history
>  + 55fcd2c...95a7e04 master     -> origin/master  (forced update)
>   815c416..78178c7  stable     -> origin/stable
>  * [new tag]         next-20100708 -> next-20100708
> cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
> cat: compat_base_tree: No such file or directory
> cat: compat_base_tree_version: No such file or directory
> cat: compat_version: No such file or directory
> cat: /var/opt/compat/compat-wireless-2.6/compat_version: No such file or directory
> scripts/Makefile.clean:17: /var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile: No such file or directory
> make[4]: *** No rule to make target `/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap/Makefile'.  Stop.
> make[3]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless/hostap] Error 2
> make[2]: *** [/var/opt/compat/compat-wireless-2.6/drivers/net/wireless] Error 2
> make[1]: *** [_clean_/var/opt/compat/compat-wireless-2.6] Error 2
> make: *** [clean] Error 2
> /usr/bin/sha1sum: *.tar.bz2: No such file or directory
>
> compat-wireless code metrics
>
>    494880 - Total upstream lines of code being pulled
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
