Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:51210 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933153AbdCaRYJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 13:24:09 -0400
Message-ID: <1490981039.27353.12.camel@perches.com> (sfid-20170331_192458_435706_C1447A7C)
Subject: Re: [PATCH] ath6kl: Add __printf verification to ath6kl_dbg
From: Joe Perches <joe@perches.com>
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Mar 2017 10:23:59 -0700
In-Reply-To: <CALLGbR+szcYFdbdh_0qBS4B_X6YQvU6CDFpR-XZvc7p3zA+ZdQ@mail.gmail.com>
References: <e4556e95a5935f591fdff67c6fb2f7ef5c7fd04f.1490914618.git.joe@perches.com>
         <CALLGbR+szcYFdbdh_0qBS4B_X6YQvU6CDFpR-XZvc7p3zA+ZdQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-31 at 10:19 -0700, Steve deRosier wrote:
> On Thu, Mar 30, 2017 at 3:57 PM, Joe Perches <joe@perches.com> wrote:
> > Fix fallout too.
[]
> My only question is why bother doing a format check on something
> that's going to be compiled out anyway?

To avoid introducing defects when writing new code
and not using the debugging code path.
