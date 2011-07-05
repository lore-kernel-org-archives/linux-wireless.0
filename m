Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54397 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805Ab1GERJM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 13:09:12 -0400
Date: Tue, 5 Jul 2011 09:59:58 -0700
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Dan Carpenter <error27@gmail.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 017/119] staging: brcm80211: change FOREACH_BSS macro to
 remove checkpatch error
Message-ID: <20110705165958.GB18531@kroah.com> (sfid-20110705_190920_160627_2744752E)
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
 <1309391303-22741-18-git-send-email-frankyl@broadcom.com>
 <20110630083700.GK14591@shale.localdomain>
 <4E0C4DB2.7090506@broadcom.com>
 <4E131B86.2030202@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E131B86.2030202@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 05, 2011 at 04:11:18PM +0200, Arend van Spriel wrote:
> On 06/30/2011 12:19 PM, Arend van Spriel wrote:
> >On 06/30/2011 10:37 AM, Dan Carpenter wrote:
> >>That's pretty ugly.  Better to leave the original in and ignore the
> >>checkpatch warning.  Or maybe do something like this:
> >>
> >>	for (idx = 0; (int) idx<   WLC_MAXBSSCFG; idx++) { \
> >>		cfg = (wlc)->bsscfg[idx];		  \
> >>		if (!cfg)				  \
> >>			continue;			  \
> >>
> >>Then #define END_FOREACH_BSS() }
> >Hi Dan,
> >
> >I agree this is not the nicest solution. It was a checkpatch error so we
> >felt an urge to fix it. A warning would have been easier to ignore. I
> >will have a look and see whether the patch can be dropped without
> >issues. Your feedback is noted so I will look for a better iteration
> >solution to replace this.
> 
> Hi Greg,
> 
> Can you please drop this patch from the series? There are no
> dependencies with the other patches.

Now dropped.

