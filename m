Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:53854 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755857AbcKCIlm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 04:41:42 -0400
Message-ID: <1478162497.1924.16.camel@perches.com> (sfid-20161103_094210_313464_C837DE34)
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine
 macpower
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>, John Heenan <john@zgus.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Nov 2016 01:41:37 -0700
In-Reply-To: <wrfjzillsan3.fsf@redhat.com>
References: <cover.1477769750.git.john@zgus.com>
         <20161030102112.GA5789@cube> <wrfjpomidp1v.fsf@redhat.com>
         <CAAye0QN0s1S25tDPNWdM6fsVNaO-wLuSy_RoOSoXeuSMeD4oNA@mail.gmail.com>
         <wrfjzillsan3.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-10-30 at 19:02 -0400, Jes Sorensen wrote:
> Code is 80 characters wide, and comments are /* */ never the ugly C++
> crap.

You might look at the recent Linus Torvalds authored commit
5e467652ffef (?printk: re-organize log_output() to be more legible")
which does both of those: c99 // comments and > 80 columns.

Absolutes are for zealots.
