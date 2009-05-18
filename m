Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:58268 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZERCab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 22:30:31 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1765508wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 19:30:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890905171809t6ad0e654jc07b6dd2d4cf6564@mail.gmail.com>
References: <4A0FF4FE.1030304@tls-tautenburg.de> <3ace41890905171600i3308f799n2a643e61fd954d4f@mail.gmail.com>
	<4A10A5C0.7090107@erley.org> <3ace41890905171809t6ad0e654jc07b6dd2d4cf6564@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 17 May 2009 19:30:13 -0700
Message-ID: <43e72e890905171930r15eaf1d7qc98dea401705b55c@mail.gmail.com>
Subject: Re: compile error compat-wireless
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Pat Erley <pat-lkml@erley.org>,
	Bringfried Stecklum <stecklum@tls-tautenburg.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2009 at 6:09 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Mon, May 18, 2009 at 1:03 AM, Pat Erley <pat-lkml@erley.org> wrote:
>
>> I got this as well, fixed it by adding #include <asm/unaligned.h> to key.c
>>
>> I have been running compat-wireless for months, so it's not a missing package
>> thing, I suspect it's an outdated headers thing.  My system has 2.6.27 headers
>> right now.
>>
>> Pat Erley
>>
>
> Hmm, sorry about that. On my system (2.6.29.3-142.fc11.x86_64) no
> change is needed to building compat-wireless.
> Maybe it is partly with old kernel heades.

Hauke Mehrtens has fixed this, I applied his patches and pushed a new
tarball out.

FWIW just also pushed out a stable tarball (based on 2.6.30-rc6).

  Luis
