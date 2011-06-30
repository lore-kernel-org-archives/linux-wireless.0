Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59081 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1F3Sdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 14:33:39 -0400
Received: by pzk9 with SMTP id 9so1966650pzk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 11:33:38 -0700 (PDT)
Date: Thu, 30 Jun 2011 21:32:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 000/119] staging: brcm80211: more code cleanup and bug
 fixed
Message-ID: <20110630183258.GB2544@shale.localdomain> (sfid-20110630_203342_735174_299E23E2)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <BANLkTikPBWvYiNc1rZEwPJTck=AzUsLncA@mail.gmail.com>
 <4E0CB587.3000209@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4E0CB587.3000209@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 30, 2011 at 10:42:31AM -0700, Henry Ptasinski wrote:
> On 06/29/2011 11:29 PM, Rafał Miłecki wrote:
> >2011/6/30 Franky Lin<frankyl@broadcom.com>:
> >>Most of these patches are brcmfmac cleanup.
> >
> >
> >Hm, interesting improvement in your "Release early, release often" strategy.
> >
> 
> Yea, we were waiting for the previous series to get applied.  Not
> sure how to make this work better.  Any process suggestions would be
> appreciated.

Maintain your own git tree.  Post patches in bunches.  If no one
comments on them within 3 days then probably you can assume they
are going to be merged.  In the [0 / X] patch say something like:

  Fixes blah blah blah.

  Applies to linux-next with the following patch sets applied:
  Message-ID: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
  Message-ID: <8888888888-88888-1-git-send-email-frankyl@broadcom.com>
  Or you can get the patches from git://whatever branch.

regards,
dan carpenter
