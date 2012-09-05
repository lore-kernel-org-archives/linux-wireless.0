Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2IEUHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 16:07:24 -0400
Date: Wed, 5 Sep 2012 15:07:16 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brad Figg <brad.figg@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback
 operation
Message-ID: <20120905200716.GF302@thinkpad-t410> (sfid-20120905_220727_887432_BA20DD59)
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <1346838562-4818-3-git-send-email-arend@broadcom.com>
 <20120905165735.GD302@thinkpad-t410>
 <50478CE9.6040103@canonical.com>
 <5047A624.7090105@broadcom.com>
 <20120905193330.GE302@thinkpad-t410>
 <5047AF77.3060903@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5047AF77.3060903@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 10:00:55PM +0200, Arend van Spriel wrote:
> On 09/05/2012 09:33 PM, Seth Forshee wrote:
> >On Wed, Sep 05, 2012 at 09:21:08PM +0200, Arend van Spriel wrote:
> >>If I can download the kernel debian package of your 3.5 kernel from
> >>somewhere that would be great.
> >
> >You can get the debs for the kernel from
> >http://people.canonical.com/~sforshee/linux-3.5.0-13.14~lp000000v201209051242/.
> >
> >Seth
> >
> >
> 
> I see the two brcmsmac patches there. Are those applied to this kernel?

Yes, they are applied to that build. Otherwise it is our stock kernel
for Ubuntu 12.10.

