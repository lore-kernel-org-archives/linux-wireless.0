Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60867 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1IUWkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 18:40:14 -0400
Received: by iaqq3 with SMTP id q3so2138878iaq.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 15:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110921175519.4c095804@mj>
References: <20110921190442.E2EB540629@repository3.orbit-lab.org> <20110921175519.4c095804@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Sep 2011 15:39:54 -0700
Message-ID: <CAB=NE6XyhjXZZuNzt49zNPWxT0LKSS9Lr=gPqVcME4M4MreCbw@mail.gmail.com> (sfid-20110922_004023_209643_15333B00)
Subject: Re: Compat-wireless release for 2011-09-21 is baked
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 21, 2011 at 2:55 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 21 Sep 2011 15:04:42 -0400 (EDT)
> compat@orbit-lab.org (Compat-wireless cronjob account) wrote:
>
>> From git://github.com/sfrothwell/linux-next
>>  + ec5d67e...39fc525 akpm-end   -> origin/akpm-end  (forced update)
>>    9d037a7..38867a2  akpm-start -> origin/akpm-start
>>  + 8c024a2...367fd59 master     -> origin/master  (forced update)
>>    9d037a7..38867a2  stable     -> origin/stable
>>  * [new tag]         next-20110921 -> next-20110921
>>
>> compat-wireless code metrics
>>
>>     812354 - Total upstream lines of code being pulled
>> Host key verification failed.
>> rsync: connection unexpectedly closed (0 bytes received so far)
>> [sender] rsync error: unexplained error (code 255) at io.c(601)
>
> OK, we are getting closer, but we are not there yet :(
>
> By the way, where is compat-user now?

Ah, yeah forgot to push that one to github and also infradead. I have
two mirrors of this tree now:

git://github.com/mcgrof/compat-user.git
git://git.infradead.org/users/mcgrof/initvals-tool.git

  Luis

  Luis
