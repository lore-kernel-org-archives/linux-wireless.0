Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:58470 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbbC1X6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 19:58:20 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	Larry.Finger@lwfinger.net, mail@beyermatthias.de
Subject: Re: [PATCH v4 00/15] checkpatch clean-up of rtl8723au's rtw_security.c
Date: Sat, 28 Mar 2015 19:58:06 -0400
Message-ID: <42015360.hrMGRCSH7X@localhost> (sfid-20150329_005837_019059_91993A08)
In-Reply-To: <1427572374.2715.2.camel@perches.com>
References: <1427547168-12078-1-git-send-email-m.v.b@runbox.com> <1427572374.2715.2.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, March 28, 2015 12:52:54 Joe Perches wrote:
> On Sat, 2015-03-28 at 08:52 -0400, M. Vefa Bicakci wrote:
> > These commits address a number of checkpatch.pl warnings and errors
> > in rtl8723au's rtw_security.c.
> 
> Hello.
> 
> This is one of those patchsets that should be
> done against Greg's staging-testing branch.
> 
> There are some commits against rtl8723au in that
> branch that will conflict with your patches.

Hello Joe,

Thank you for letting me know. Given the discussion arising from the 3rd 
version of the patches, I should have used (or at least checked) the 
staging-testing branch.

I rebased the commits against the staging-testing branch and corrected 
the merge conflicts. I hope to send the 5th version of the patches out 
for review soon.

Vefa

