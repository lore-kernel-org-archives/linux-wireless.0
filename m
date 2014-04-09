Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47520 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbaDIQpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 12:45:20 -0400
Date: Wed, 9 Apr 2014 12:42:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@adurom.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 1/4] rtl8180: change module name in rtl818x_pci
Message-ID: <20140409164236.GD29924@tuxdriver.com> (sfid-20140409_184526_194084_0F3B89F5)
References: <877g74i8jv.fsf@purkki.adurom.net>
 <1396981525-28078-1-git-send-email-andrea.merello@gmail.com>
 <20140409161034.GC29924@tuxdriver.com>
 <CAN8YU5N60UqgE3WEZ7BLQb2_BMd_H5CWkP8snNoQm5qxYRiFcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN8YU5N60UqgE3WEZ7BLQb2_BMd_H5CWkP8snNoQm5qxYRiFcQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NM, I've got them -- they just got sorted strangely in my mailbox...

On Wed, Apr 09, 2014 at 06:30:14PM +0200, Andrea Merello wrote:
> Yes, it is.
> It seems that at least the wireless ML received it.
> http://marc.info/?l=linux-wireless&m=139662852419525&w=2
> 
> BTW I can resend if you need it.
> 
> On Wed, Apr 9, 2014 at 6:10 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > I see parts 1, 3, and 4/4.  Is there a part 2/4 that I missed?
> >
> > On Tue, Apr 08, 2014 at 08:25:25PM +0200, Andrea Merello wrote:
> >> From: Larry Finger <Larry.Finger@lwfinger.net> [ original patch ]
> >>
> >> rtl8180 driver can handle also rtl8185 and rtl8187SE cards,
> >> however in userspace tools (network manager) it still appares
> >> as "rtl8180".
> >> This might lead the user to think the wrong driver is in use.
> >>
> >> This patch changes module name to "rtl818x_pci" that should be
> >> more explanatory.
> >>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net> [ original patch ]
> >> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
> >> ---
> >>  drivers/net/wireless/rtl818x/rtl8180/Makefile | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rtl818x/rtl8180/Makefile b/drivers/net/wireless/rtl818x/rtl8180/Makefile
> >> index 08b056d..21005bd 100644
> >> --- a/drivers/net/wireless/rtl818x/rtl8180/Makefile
> >> +++ b/drivers/net/wireless/rtl818x/rtl8180/Makefile
> >> @@ -1,5 +1,5 @@
> >> -rtl8180-objs         := dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
> >> +rtl818x_pci-objs     := dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
> >>
> >> -obj-$(CONFIG_RTL8180)        += rtl8180.o
> >> +obj-$(CONFIG_RTL8180)        += rtl818x_pci.o
> >>
> >>  ccflags-y += -Idrivers/net/wireless/rtl818x
> >> --
> >> 1.8.3.2
> >>
> >>
> >
> > --
> > John W. Linville                Someday the world will need a hero, and you
> > linville@tuxdriver.com                  might be all we have.  Be ready.
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
