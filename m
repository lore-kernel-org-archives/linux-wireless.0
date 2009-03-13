Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:23809 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbZCMWLs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 18:11:48 -0400
Received: by wf-out-1314.google.com with SMTP id 28so679072wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 15:11:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49BAD5A8.4040406@f2s.com>
References: <49BAD5A8.4040406@f2s.com>
Date: Fri, 13 Mar 2009 15:11:46 -0700
Message-ID: <43e72e890903131511v3dc32341y5de5d39c585cd43e@mail.gmail.com> (sfid-20090313_231152_992846_E337AC8B)
Subject: Re: [PATCH] compat-2.6: Fix admin-update.sh creating spurious
	include/linux/unaligned/unaligned/ directory
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: Max Bowsher <maxb@f2s.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2009 at 2:52 PM, Max Bowsher <maxb@f2s.com> wrote:
> Hi,
>
> I noticed that if compat-wireless-2.6's admin-update.sh is run twice in
> a row without cleaning, it erroneously copies the
> include/linux/unaligned/* files into an
> include/linux/unaligned/unaligned/ directory.
>
> Patch below making trivial changes to the script to avoid this.
>
> Thanks,
> Max.

Thanks applied.

  Luis
