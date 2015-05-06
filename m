Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47965 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbbEFP6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 11:58:34 -0400
Date: Wed, 6 May 2015 11:58:33 -0400
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "kyle@infradead.org" <kyle@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"Guo, Chaohong" <chaohong.guo@intel.com>
Subject: Re: pull request: update for -12.ucode firmware for Intel WiFi
 devices driven by iwlmvm
Message-ID: <20150506155833.GF27807@merlin.infradead.org> (sfid-20150506_175837_788786_5D168B1C)
References: <1430656195.25666.8.camel@intel.com>
 <0BA3FCBA62E2DC44AF3030971E174FB31B6FFF56@hasmsx107.ger.corp.intel.com>
 <20150505161627.GE27807@merlin.infradead.org>
 <1430850103.4905.1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430850103.4905.1.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2015 at 06:21:43PM +0000, Grumbach, Emmanuel wrote:
> On Tue, 2015-05-05 at 12:16 -0400, Kyle McMartin wrote:
> > On Sun, May 03, 2015 at 12:32:05PM +0000, Grumbach, Emmanuel wrote:
> > > 
> > > 
> > > > 
> > > > Dear linux-firmware maintainers,
> > > > 
> > > > Intel released a new version of the firmware for the devices below:
> > > > 3160, 7260 and 7265.
> > > > This release fixes disconnections and stability issues.
> > > 
> > > Err - the paste button worked too well. Sorry...
> > > 
> > 
> > No worries. :-)
> 
> Last minute update... Bug was discovered in latest firmware.
> Please cherry-pick 888ea193da7f6e3f03758e89bd1785d3fa393760.
> 

Will do -- I hadn't actually pushed it out, so it's not in the wild yet.

--Kyle
