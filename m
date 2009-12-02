Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41619 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbZLBCGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 21:06:08 -0500
Subject: Re: Panic in iwl3945 driver
From: Zhu Yi <yi.zhu@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259693544.4653.126.camel@rc-desk>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>  <1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop> <1259659724.12157.110.camel@debian>
	 <1259693544.4653.126.camel@rc-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 10:06:12 +0800
Message-ID: <1259719572.12157.120.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-02 at 02:52 +0800, Chatre, Reinette wrote:
> I agree with your conclusion here that r8 is 0 at this point. I am
> very
> confused how this can be since the two lines above the ones you pasted
> here are:
> 
> 0x0000000000016683 <iwl3945_rx_reply_tx+291>:»­­mov    (%rdx,%rax,1),%
> r8
> 0x0000000000016687 <iwl3945_rx_reply_tx+295>:»­­mov    $0x0,%rdx
> 
> From the information in the post you refer to we have rdx as
> 0xffffffffa0c85f40 and rax as 0x4f. Since r8 is initialized above from
> these two registers ... how could it be that r8 ends up as zero? 

Is it related? They are memory address references.

Thanks,
-yi

