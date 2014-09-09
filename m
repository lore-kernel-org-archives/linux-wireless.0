Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45485 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaIINaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 09:30:12 -0400
Date: Tue, 9 Sep 2014 09:26:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: chandrika parimoo <chandrika3437@gmail.com>,
	brcm80211-dev-list@broadcom.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Mesh Support in brcmsmac
Message-ID: <20140909132623.GD29412@tuxdriver.com> (sfid-20140909_153016_637354_39E6BCAD)
References: <CACHGq=AYtyCh2s_h_UtBtnH4TdHuw+gHeXhKjT2kVQSLcBSrow@mail.gmail.com>
 <540ED666.9070101@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <540ED666.9070101@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 09, 2014 at 12:28:54PM +0200, Arend van Spriel wrote:
> + linux-wireless
> 
> On 09/09/14 12:22, chandrika parimoo wrote:
> >Hello,
> >
> >I have broadcom bcm4313 card and am using brcmsmac driver which does not
> >have mesh support currently.
> >I wanted to know if there is a workaround for it?
> 
> No workaround. I am not familiar with wireless mesh networking. I suppose
> there are people on the linux-wireless mailing list who know what is needed
> from a mac80211 driver (like brcmsmac) to enable mesh networking.

The main things is the beacons, no?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
