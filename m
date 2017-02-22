Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:39195 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932748AbdBVQUJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 11:20:09 -0500
Message-ID: <1487780395.14159.10.camel@perches.com> (sfid-20170222_172037_248567_9C969DFF)
Subject: Re: [PATCH] ath10k: Modify macros to fix style issues
From: Joe Perches <joe@perches.com>
To: Marcin Rokicki <marcin.rokicki@gmail.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 22 Feb 2017 08:19:55 -0800
In-Reply-To: <CAN6SofZJjMmdkwqtD-amUTHzFJyQAYEKJUgOeHPKJEX7w0fD=g@mail.gmail.com>
References: <1487751327-2917-1-git-send-email-marcin.rokicki@tieto.com>
         <1487763244.14159.6.camel@perches.com>
         <CAM8WyvFtUpWmw+hp6e+d6KY9yp9Ux=2827vqE3JUMwYii9wmFw@mail.gmail.com>
         <CAN6SofaeUUBwJSromwC_WmLC8GpCQMu__rKwNZM5PiKGocJo4g@mail.gmail.com>
         <CAN6SofZJjMmdkwqtD-amUTHzFJyQAYEKJUgOeHPKJEX7w0fD=g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fyi Marcin, the reason this isn't getting on the list
 is because your 3 tries have all included text and html)

On Wed, 2017-02-22 at 14:31 +0100, Marcin Rokicki wrote:
> > 
> > Here is an alternate style used a few times in the kernel
> > 
> > Maybe it'd be nicer to change the macros to something like
> > 
> > #define CASE_STR(x) case x: return #x
> > 
> > and just return NULL after the switch/case block
> > 
> > Maybe make that a global macro and consolidate the various
> > uses to a single style

[]

> This alternate style used few times in the kernel cause that
> checkpatch.pl prints
> such messages:
>   - ERROR: Macros with complex values should be enclosed in parentheses
>   - WARNING: Macros with flow control statements should be avoided
> 
> for "all" of your examples - except fm10k which is implemented (almost) in
> the same way like above patch
> but still prints:
>  - ERROR: Macros with multiple statements should be enclosed in a do -
> while loop

Yes, checkpatch is and will always be imperfect.
It's just a bunch of regex tests.

Anyway, the point of my email was to highlight a
possible line count reduction and an opportunity
to standardize a style.

cheers, Joe
