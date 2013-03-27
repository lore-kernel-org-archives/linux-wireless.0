Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:60945 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950Ab3C0PM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 11:12:56 -0400
Date: Wed, 27 Mar 2013 11:10:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@redhat.com>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: P2P support in brcmfmac
Message-ID: <20130327151053.GD2146@tuxdriver.com> (sfid-20130327_161300_035717_78F44FC7)
References: <5152DD47.2080501@broadcom.com>
 <20130327122216.GA2146@tuxdriver.com>
 <1364387698.8388.1.camel@jlt4.sipsolutions.net>
 <20130327124422.GB2146@tuxdriver.com>
 <1364388675.8388.5.camel@jlt4.sipsolutions.net>
 <51530267.5020705@broadcom.com>
 <1364395136.8388.9.camel@jlt4.sipsolutions.net>
 <5153082B.6080000@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5153082B.6080000@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 27, 2013 at 03:54:35PM +0100, Arend van Spriel wrote:
> On 03/27/2013 03:38 PM, Johannes Berg wrote:

> > Or you could just remove the module parameter *and* advertisting the
> > P2P_DEVICE interface type, that would be a very small patch to "fix" the
> > API by disabling it for that kernel version. OTOH, I'm not sure if
> > that's a concern for you. For me, it wouldn't be a concern because we
> > mostly use compat-wireless anyway, but your situation might be
> > different.
> 
> That is indeed what I guessed the patch should look like, which would
> make P2P unavailable for 3.9 regardless the wpa_supplicant version used.
> But indeed there is always compat-drivers aka. compat-wireless so I am
> not that concerned.

I think this is the patch we need in order to avoid messy confusion later...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
