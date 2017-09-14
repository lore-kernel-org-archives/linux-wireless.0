Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37190 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINPNn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Sep 2017 11:13:43 -0400
Received: by mail-wm0-f67.google.com with SMTP id f4so390821wmh.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 08:13:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170914143134.5ybcusoqu74wf6d7@home.ouaza.com>
References: <20170914143134.5ybcusoqu74wf6d7@home.ouaza.com>
From: Steve deRosier <derosier@gmail.com>
Date: Thu, 14 Sep 2017 08:13:42 -0700
Message-ID: <CALLGbRJj4=2FT6DDenDL-o2tk2dJT79-gBcdSToGTSti_ZnEag@mail.gmail.com> (sfid-20170914_171347_414641_E0EA5682)
Subject: Re: Kernel developer to work on wifi injection in mainline
To: Raphael Hertzog <buxy@kali.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, devel@kali.org,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raphael,

On Thu, Sep 14, 2017 at 7:31 AM, Raphael Hertzog <buxy@kali.org> wrote:
> (Please keep-me in CC and use reply-to all)
>
...
>
> Thus we are looking for a kernel developer that we could work with on a
> contractor basis to:
> - make wifi injection work on the current Kali kernel on various drivers
>   that we want to support
> - upstream as much as possible of changes needed for wifi injection to
>   work
> - ensure continued support of the feature in new Linux releases
>

I do this sort of consulting work. While I kept this reply on the list
due to your instructions, I'll send you information directly from my
consulting address.

> I wonder whether there are non-technical hurdles that would prevent
> merging of wifi injection patches. Are there legal challenges to this for
> instance?
>

I don't think there would be a legal challenge provided the code is
yours to sign-off on and isn't patent encumbered.

Personally, I think the biggest issue is interest of the Linux
community as a whole. In other words, if you can convince maintainers
that the change is:
1. valuable to the Linux community members
2. not harmful to the community as a whole
3. worth maintaining (and in part will be responsible for maintaining)
4. not purely based on closed business reasons
then I think it'll be possible to get it upstream.

I'm not that familiar with the patch(es) in question but from my quick
look I don't see an obvious blocking issue with the concepts here.

- Steve
