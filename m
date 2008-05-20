Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:53807 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759818AbYETBBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 21:01:37 -0400
Subject: Re: iwlwifi Makefile issue in compat-wireless-2008-05-18
From: Zhu Yi <yi.zhu@intel.com>
To: John Goulah <jgoulah@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <183c1cc10805190610h176cb8fcx54e6755fb5f36cfb@mail.gmail.com>
References: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
	 <1211168475.31033.9.camel@debian.sh.intel.com>
	 <183c1cc10805190610h176cb8fcx54e6755fb5f36cfb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 May 2008 09:01:03 +0800
Message-Id: <1211245264.2532.24.camel@debian.sh.intel.com> (sfid-20080520_030145_401374_4DB38522)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-19 at 09:10 -0400, John Goulah wrote:
> 
> Thats odd, my kernel is fairly new -- 2.6.24.4
> 
> I custom compiled it, and I dont see anything related to IWL  in my
> .config file strangely enough.  I guess its possible my .config got
> out of sync somehow, or is this what you would consider "old" ?

Yup, .24 is old. The patch will make its way to .26 (not released yet).

Thanks,
-yi

