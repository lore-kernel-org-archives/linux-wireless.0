Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab3HFMjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:39:46 -0400
Message-ID: <1375792779.8219.16.camel@jlt4.sipsolutions.net> (sfid-20130806_143958_225515_7DB84C41)
Subject: Re: [PATCH 3.10 0/3] Enable 7000 device family on 3.10
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 06 Aug 2013 14:39:39 +0200
In-Reply-To: <20130802090234.GA20470@kroah.com> (sfid-20130802_110125_328939_A32618A5)
References: <1373888700-3040-1-git-send-email-emmanuel.grumbach@intel.com>
	 <20130802090234.GA20470@kroah.com> (sfid-20130802_110125_328939_A32618A5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Emmanuel is on vacation, I'll cover for him]

On Fri, 2013-08-02 at 17:02 +0800, Greg KH wrote:
> On Mon, Jul 15, 2013 at 02:44:57PM +0300, Emmanuel Grumbach wrote:
> > This small patch series enables 7260 and 3160 devices on 3.10
> > kernel. Three patches are already in linux.git (3.11-rc1).
> > One patch is 3.10 specific and disables configuration that is not
> > supported in 3.10.
> 
> I need the git commit id of these patches in Linus's tree before I can
> apply them.  Please resend them with that information.

The second and third patch does have it, and the first patch is only
relevant for 3.10 since 3.11 will have more device types enabled, we
just didn't get all the code in. This seems to be described in the
commit log, do you want more details?

johannes

