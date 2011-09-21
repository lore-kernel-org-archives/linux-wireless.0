Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:22913 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab1IUAkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 20:40:37 -0400
Subject: Re: [PATCH 7/8] iwlagn: pending frames musn't be incremented if
 agg is on
From: wwguy <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
In-Reply-To: <CALSq=Ba0-Jryh=cU5bp9MpeTtOAru3YqavuTtwuudjO2_Ri5Ag@mail.gmail.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1316558247-10018-8-git-send-email-wey-yi.w.guy@intel.com>
	 <CALSq=Ba0-Jryh=cU5bp9MpeTtOAru3YqavuTtwuudjO2_Ri5Ag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 17:35:15 -0700
Message-ID: <1316565315.23660.2.camel@wwguy-ubuntu> (sfid-20110921_024040_778567_BBC7A3AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-20 at 16:51 -0700, Daniel Halperin wrote:
> On Tue, Sep 20, 2011 at 3:37 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> >
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >
> > During my works on the transport layer I removed code that updated
> > a local variable (is_agg) that is needed to keep the pending_frames
> > count up to date. Fix this.
> 
> Seems like a big bug.
> 
> Is this a bugfix for a patch earlier in the series or a patch that's
> already been accepted. If the former, why not merge? If the latter,
> why not CC'ed as a fix to an earlier version of the kernel?
> 
good point, I will work with Emmanuel to figure out if we need to
backport to the earlier kernel

Thanks for catch this one

Wey


