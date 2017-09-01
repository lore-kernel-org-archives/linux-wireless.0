Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0145.hostedemail.com ([216.40.44.145]:54114 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751443AbdIAIV0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 04:21:26 -0400
Message-ID: <1504254083.2361.7.camel@perches.com> (sfid-20170901_102131_460359_CB2B4330)
Subject: Re: [PATCH 1/2] iwlwifi: fix long debug print
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>
Date: Fri, 01 Sep 2017 01:21:23 -0700
In-Reply-To: <87k21irg1g.fsf@kamboji.qca.qualcomm.com>
References: <20170825082730.31388-1-luca@coelho.fi>
         <20170825082730.31388-2-luca@coelho.fi>
         <1504216665.2786.48.camel@perches.com>
         <1504244238.31031.24.camel@coelho.fi> <1504246520.2361.3.camel@perches.com>
         <87k21irg1g.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-01 at 11:15 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> > On Fri, 2017-09-01 at 08:37 +0300, Luca Coelho wrote:
> > > On Thu, 2017-08-31 at 14:57 -0700, Joe Perches wrote:
> > > > On Fri, 2017-08-25 at 11:27 +0300, Luca Coelho wrote:
> > > > > From: Liad Kaufman <liad.kaufman@intel.com>
> > > > > There is a debug print that sometimes reaches over
> > > > > 110 chars, thus generating a warning in those cases.
[]
> > It might make sense to add a comment to describe these
> > trace events coming from TRACE_EVENT(iwlwifi_dbg,
> > 
> > All the IWL_DEBUG_<foo> use this trace message maximum.
> 
> Unfortunately the patch is already commited to wireless-drivers-next so
> we can't change the commit log anymore.

No worries about the commit.
It'd be useful to add a comment to the code.
