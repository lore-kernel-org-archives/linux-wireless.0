Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55319 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1HBPC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 11:02:29 -0400
Date: Tue, 2 Aug 2011 10:54:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: revert patch request
Message-ID: <20110802145401.GC14167@tuxdriver.com> (sfid-20110802_170232_739542_390F0885)
References: <E9954878DD1FB34FAE5187FB88C58A3501995533C7@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501995533C7@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2011 at 07:41:28AM -0700, Guy, Wey-Yi W wrote:
> Hi John,
> 
> 
> 
> I need to revert one of my patch back in 2.6.39, what is the best way to
> 
> do it since that area of code was changed after that.
> 
> 
> 
> 
> 
> commit 9dc2153315650eae220898668b6aa56a25c130be
> 
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com<mailto:wey-yi.w.guy@intel.com>>
> 
> Date:   Mon Jan 17 11:05:52 2011 -0800
> 
> 
> 
>     iwlwifi: always support idle mode for agn devices
> 
> 
> 
>     For agn devices, always support idle mode which help power
> 
>     consumption in idle unassociated state.
> 
> 
> 
>     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com<mailto:wey-yi.w.guy@intel.com>>
> 
> 
> 
> 
> 
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2312
> 
> 
> 
> Thanks
> 
> Wey

Perhaps you can resolve the conflicts w/ the revert and just post
it as a patch.  The changelog should indicate what you are reverting
(and why), of course.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
