Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3C0MfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 08:35:13 -0400
Message-ID: <1364387698.8388.1.camel@jlt4.sipsolutions.net> (sfid-20130327_133521_754134_731541B4)
Subject: Re: P2P support in brcmfmac
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@redhat.com>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 27 Mar 2013 13:34:58 +0100
In-Reply-To: <20130327122216.GA2146@tuxdriver.com>
References: <5152DD47.2080501@broadcom.com>
	 <20130327122216.GA2146@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 08:22 -0400, John W. Linville wrote:
> On Wed, Mar 27, 2013 at 12:51:35PM +0100, Arend van Spriel wrote:
> 
> > In 3.9 we introduced P2P support in brcmfmac which was functional using
> > current wpa_supplicant P2P support, but we did not yet support the
> > P2P_DEVICE user-space API.
> > 
> > Last week I enabled that in brcmfmac testing it with wpa_supplicant
> > patches for P2P_DEVICE support from David Spinadel. So I do have a
> > couple of brcmfmac patches to make that work and would like to submit
> > those for 3.9 although it is not strictly a bug fix. Would you consider
> > taking these?
> 
> That doesn't sound to me like something that would be worthy of such
> an exception.

Maybe just make a small patch to disable the other API, so we don't end
up having to support both?

johannes

