Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:36519 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751594AbZFBAth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 20:49:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 1 Jun 2009 17:47:31 -0700
Subject: RE: [PATCH 3/4 v2] libertas: implement function init/shutdown
	commands for SD8688
Message-ID: <477F20668A386D41ADCC57781B1F704301E90675ED@SC-VEXCH1.marvell.com>
References: <1243465413-4997-1-git-send-email-bzhao@marvell.com>
 <20090601183453.GD3386@tuxdriver.com>
In-Reply-To: <20090601183453.GD3386@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

The new patch against "master-2009-06-01" has been submitted to the lists:

[PATCH] libertas: improve function init/shutdown handling for SD8688

Thanks,

Bing

> -----Original Message-----
> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Monday, June 01, 2009 11:35 AM
> To: Bing Zhao
> Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 3/4 v2] libertas: implement function init/shutdown commands for SD8688
> 
> On Wed, May 27, 2009 at 04:03:33PM -0700, Bing Zhao wrote:
> > SD8688 is a WLAN/Bluetooth combo chip and both functions are supported
> > in a single firmware image. FUNC_INIT and FUNC_SHUTDOWN commands are
> > implemented to utilize the multiple function feature.
> >
> > When SD8688 card is inserted, the firmware image should be downloaded
> > only once through either WLAN function (Libertas driver) or Bluetooth
> > function (Bluetooth driver).
> >
> > This patch adds function init/shutdown for SD8688 WLAN function only.
> >
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> 
> I already merged the 5/19 version.  Could you send a patch rebased
> on wireless-testing?
> 
> John
> --
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
