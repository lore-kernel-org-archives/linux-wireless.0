Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:60248 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752531Ab3C0Mqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 08:46:48 -0400
Date: Wed, 27 Mar 2013 08:44:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@redhat.com>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: P2P support in brcmfmac
Message-ID: <20130327124422.GB2146@tuxdriver.com> (sfid-20130327_134651_978568_E9676660)
References: <5152DD47.2080501@broadcom.com>
 <20130327122216.GA2146@tuxdriver.com>
 <1364387698.8388.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364387698.8388.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 27, 2013 at 01:34:58PM +0100, Johannes Berg wrote:
> On Wed, 2013-03-27 at 08:22 -0400, John W. Linville wrote:
> > On Wed, Mar 27, 2013 at 12:51:35PM +0100, Arend van Spriel wrote:
> > 
> > > In 3.9 we introduced P2P support in brcmfmac which was functional using
> > > current wpa_supplicant P2P support, but we did not yet support the
> > > P2P_DEVICE user-space API.
> > > 
> > > Last week I enabled that in brcmfmac testing it with wpa_supplicant
> > > patches for P2P_DEVICE support from David Spinadel. So I do have a
> > > couple of brcmfmac patches to make that work and would like to submit
> > > those for 3.9 although it is not strictly a bug fix. Would you consider
> > > taking these?
> > 
> > That doesn't sound to me like something that would be worthy of such
> > an exception.
> 
> Maybe just make a small patch to disable the other API, so we don't end
> up having to support both?

Maybe I misunderstood.  So brcmfmac currently supports a P2P API
that is not otherwise available and which we don't want to support
in the future?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
