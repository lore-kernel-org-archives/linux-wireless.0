Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbbBXRt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 12:49:56 -0500
Date: Tue, 24 Feb 2015 12:49:55 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "kyle@infradead.org" <kyle@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhao, Yingying" <yingying.zhao@intel.com>,
	"linux-firmware@kernel.org" <linux-firmware@kernel.org>
Subject: Re: pull request: new firmware for Intel wireless Intel 3160 / 7260
 / 7265 / 7265D devices
Message-ID: <20150224174955.GL30928@merlin.infradead.org> (sfid-20150224_185000_111020_C4AEE235)
References: <1422999252.29907.18.camel@egrumbacBox>
 <1422999568.29907.24.camel@egrumbacBox>
 <20150206091506.GE30928@merlin.infradead.org>
 <1423215113.8145.0.camel@egrumbacBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423215113.8145.0.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 06, 2015 at 09:31:52AM +0000, Grumbach, Emmanuel wrote:
> On Fri, 2015-02-06 at 04:15 -0500, Kyle McMartin wrote:
> > On Tue, Feb 03, 2015 at 09:39:28PM +0000, Grumbach, Emmanuel wrote:
> > > Hi,
> > > 
> > > This is a pull request for new firmwares for the Intel wireless devices
> > > mentioned in the subject.
> > > 
> > > I replace -10.ucode with new ones (that includes bug fixes).
> > > I add the brand new -12.ucode.
> > > 
> > > Please pull.
> > > 
> > > The following changes since commit
> > > 38e5405c96d10bb42b629b45210c46166461fc21:
> > > 
> > 
> > oh, heh, only 1 commit, not 3. ;-)
> > 
> 
> Well - actually 2 commits. You missed the one that updates the -10.ucode
> from 23.11.10.0 23.12.10.0.
> 

Ah, oops, I've pulled this in now.

--Kyle
