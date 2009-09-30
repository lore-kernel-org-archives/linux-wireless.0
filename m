Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZI3VxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 17:53:07 -0400
Subject: Re: [stable] Making Intel WiFi Link 1000 usable in 2.6.31
From: reinette chatre <reinette.chatre@intel.com>
To: Greg KH <greg@kroah.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090930212447.GB30093@kroah.com>
References: <1254339259.26521.1645.camel@rc-desk>
	 <20090930212447.GB30093@kroah.com>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 14:53:10 -0700
Message-Id: <1254347590.26521.1656.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-09-30 at 14:24 -0700, Greg KH wrote:
> On Wed, Sep 30, 2009 at 12:34:19PM -0700, reinette chatre wrote:
> > 
> > commit cc0f555d511a5fe9d4519334c8f674a1dbab9e3a
> > Author: Jay Sternberg <jay.e.sternberg@intel.com>
> > Date:   Fri Jul 17 09:30:16 2009 -0700
> > 
> >     iwlwifi: Handle new firmware file with ucode build number in header
> > 
> > commit cce53aa347c1e023d967b1cb1aa393c725aedba5
> > Author: Jay Sternberg <jay.e.sternberg@intel.com>
> > Date:   Fri Jul 17 09:30:22 2009 -0700
> > 
> >     iwlwifi: update 1000 series API version to match firmware
> > 
> > commit 02c06e4abc0680afd31bf481a803541556757fb6
> > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Date:   Fri Jul 17 09:30:14 2009 -0700
> > 
> >     iwlagn: modify digital SVR for 1000
> > 
> > commit 415e49936b4b29b34c2fb561eeab867d41fc43a6
> > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Date:   Thu Aug 13 13:30:54 2009 -0700
> > 
> >     iwlwifi: traverse linklist to find the valid OTP block
> > 
> > commit f7ea097d9b4e61a816c041c92548aad7c7ed7915
> > Author: Reinette Chatre <reinette.chatre@intel.com>
> > Date:   Fri Jul 24 11:13:12 2009 -0700
> > 
> >     iwlagn: fix null pointer access during ucode load on 1000
> > 
> > Thank you very much
> 
> Is this the order in which they should be applied?

This is the correct order, but the last two patches need to be ported to
2.6.31. I will send out new versions.

Reinette


