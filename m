Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53353 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIKRew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 13:34:52 -0400
Message-ID: <1410456874.32328.19.camel@hadess.net> (sfid-20140911_193455_757248_E39702A5)
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Bastien Nocera <hadess@hadess.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Sep 2014 19:34:34 +0200
In-Reply-To: <5410560D.8030300@lwfinger.net>
References: <1410256608.4077.7.camel@hadess.net>
		 <540F54B1.8040409@lwfinger.net> <1410292835.4077.21.camel@hadess.net>
		 <540F61FE.2050404@lwfinger.net>
		 <7234781D-5B78-404A-B945-D090938777C7@hadess.net>
		 <D08A763F-AD50-449D-98C6-B82866F49480@holtmann.org>
		 <54100FF7.5060904@broadcom.com> <1410342645.4077.28.camel@hadess.net>
	 <54102635.2040403@broadcom.com> <5410560D.8030300@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-10 at 08:45 -0500, Larry Finger wrote:
> On 09/10/2014 05:21 AM, Arend van Spriel wrote:
> > On 09/10/14 11:50, Bastien Nocera wrote:
> >>
> >> Indeed. That did the trick.
> >>
> >> mmc0:0001 is the builtin storage, mmc1:0001:1 however is an unbound
> >> device with vendor 0x024c and device 0xb723 (modalias:
> >> sdio:c07v024CdB723). More interestingly class is 0x07, which udev
> >> interprets as "WLAN interface".
> >
> > Now you have to find and load the right driver.
> 
> In response to a question from me, my contact at Realtek sent me such a driver 
> last night. I have forwarded it to Bastien and he should be in business soon.

And I'm in business now, after some API porting. If you import the
driver into your repo, I'd be happy to help out with some of the
cleaning up, as you've done in: https://github.com/lwfinger/rtl8723au

Cheers

