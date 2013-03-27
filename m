Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:59898 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751035Ab3C0MYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 08:24:18 -0400
Date: Wed, 27 Mar 2013 08:22:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: P2P support in brcmfmac
Message-ID: <20130327122216.GA2146@tuxdriver.com> (sfid-20130327_132421_276395_33D0469D)
References: <5152DD47.2080501@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5152DD47.2080501@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 27, 2013 at 12:51:35PM +0100, Arend van Spriel wrote:

> In 3.9 we introduced P2P support in brcmfmac which was functional using
> current wpa_supplicant P2P support, but we did not yet support the
> P2P_DEVICE user-space API.
> 
> Last week I enabled that in brcmfmac testing it with wpa_supplicant
> patches for P2P_DEVICE support from David Spinadel. So I do have a
> couple of brcmfmac patches to make that work and would like to submit
> those for 3.9 although it is not strictly a bug fix. Would you consider
> taking these?

That doesn't sound to me like something that would be worthy of such
an exception.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
