Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab0AUVMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 16:12:03 -0500
Date: Thu, 21 Jan 2010 13:05:29 -0800
From: Greg KH <greg@kroah.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH 2.6.{32, 31}] iwlwifi: power up all devices
 for EEPROM read
Message-ID: <20100121210529.GA5182@kroah.com>
References: <1264076545-12223-1-git-send-email-sgruszka@redhat.com>
 <20100121205138.GC14716@kroah.com>
 <1264107595.21458.181.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264107595.21458.181.camel@rchatre-DESK>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 12:59:55PM -0800, reinette chatre wrote:
> Hi Greg,
> 
> On Thu, 2010-01-21 at 12:51 -0800, Greg KH wrote:
> > On Thu, Jan 21, 2010 at 01:22:25PM +0100, Stanislaw Gruszka wrote:
> > > commit f8701fe3aec24fcfb0dfa19aab47904611f96daf upstream
> > > 
> > > On 2.6.31 and 2.6.32 iwl3945 crash during kdump, I discovered
> > > above upstream commit fix that.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > > I tested patch on 2.6.32 with iwl3945 - it fix kdump, and on 2.6.31
> > > with iwl5300 - no regression notice.
> > 
> > Thanks for the backport, I've queued this up now.
> 
> This backport is on top of patches that are not present in 2.6.31 or
> 2.6.32. Please see the message I sent in response to the original post.
> Could we please finish that discussion first before looking into merging
> this patch?

Oops, ok, I'll go drop it, thanks for the quick response.

greg k-h
