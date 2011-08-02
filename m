Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:65241 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab1HBPMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 11:12:05 -0400
Subject: Re: revert patch request
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20110802145401.GC14167@tuxdriver.com>
References: <E9954878DD1FB34FAE5187FB88C58A3501995533C7@orsmsx506.amr.corp.intel.com>
	 <20110802145401.GC14167@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Aug 2011 08:07:33 -0700
Message-ID: <1312297653.1713.0.camel@wwguy-ubuntu> (sfid-20110802_171209_939008_43A616DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-02 at 07:54 -0700, John W. Linville wrote:
> On Tue, Aug 02, 2011 at 07:41:28AM -0700, Guy, Wey-Yi W wrote:
> > Hi John,
> > 
> > 
> > 
> > I need to revert one of my patch back in 2.6.39, what is the best way to
> > 
> > do it since that area of code was changed after that.
> > 
> > 
> > 
> > 
> > 
> > commit 9dc2153315650eae220898668b6aa56a25c130be
> > 
> > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com<mailto:wey-yi.w.guy@intel.com>>
> > 
> > Date:   Mon Jan 17 11:05:52 2011 -0800
> > 
> > 
> > 
> >     iwlwifi: always support idle mode for agn devices
> > 
> > 
> > 
> >     For agn devices, always support idle mode which help power
> > 
> >     consumption in idle unassociated state.
> > 
> > 
> > 
> >     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com<mailto:wey-yi.w.guy@intel.com>>
> > 
> > 
> > 
> > 
> > 
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2312
> > 
> > 
> > 
> > Thanks
> > 
> > Wey
> 
> Perhaps you can resolve the conflicts w/ the revert and just post
> it as a patch.  The changelog should indicate what you are reverting
> (and why), of course.
> 
Thanks, I will try that

Wey




