Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44739 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJSFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 14:05:40 -0400
Date: Fri, 10 Jun 2011 15:05:55 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2011-06-08
Message-ID: <20110610180555.GC2663@joana> (sfid-20110610_200546_264748_3DFFFACC)
References: <20110608194658.GD13036@joana>
 <20110609175933.GA16802@tuxdriver.com>
 <20110609183430.GA2533@joana>
 <20110610175302.GD2665@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110610175302.GD2665@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2011-06-10 13:53:03 -0400]:

> On Thu, Jun 09, 2011 at 03:34:31PM -0300, Gustavo F. Padovan wrote:
> > * John W. Linville <linville@tuxdriver.com> [2011-06-09 13:59:34 -0400]:
> > 
> > > On Wed, Jun 08, 2011 at 04:46:58PM -0300, Gustavo F. Padovan wrote:
> 
> > > >       Bluetooth: Kill set but unused variable 'cmd' in cmtp_recv_capimsg()
> > > 
> > > Well, the patch submitter sounds familiar.  :-)  But killing an unused
> > > variable isn't a bug fix.  It doesn't do any damage, but I suspect that
> > > Dave expects to be held to the same standards as everyone else.
> > > 
> > > Can you drop that one (and reapply it for 3.1)?  Sorry for the trouble...
> > 
> > Sorry for that, I tough it was not that bad fix this for 3.0. New pull request
> > follows. Thanks a lot!
> 
> > Stephen Boyd (1):
> >       Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
> 
> Sorry, I missed this one too -- can you redirect it for 3.1 as well?

The following changes since commit 51e65257142a87fe46a1ce5c35c86c5baf012614:            
                                                                                        
  iwlegacy: fix channel switch locking (2011-06-08 14:19:05 -0400)                      
                                                                                        
are available in the git repository at:                                                 
  master.kernel.org:/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master          
                                                                                        
David Miller (1):                                                                       
      Bluetooth: Do not ignore errors returned from strict_strtol()                     
                                                                                        
Filip Palian (1):                                                                       
      Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.                    
                                                                                        
Luiz Augusto von Dentz (1):                                                             
      Bluetooth: fix shutdown on SCO sockets                                            
                                                                                        
Ville Tervo (1):                                                                        
      Bluetooth: Do not send SET_EVENT_MASK for 1.1 and earlier devices                 
                                                                                        
 drivers/bluetooth/btmrvl_debugfs.c |   12 ++++++++++++
 net/bluetooth/hci_event.c          |   18 ++++++++++--------
 net/bluetooth/l2cap_sock.c         |    1 +
 net/bluetooth/rfcomm/sock.c        |    1 +
 net/bluetooth/sco.c                |   13 ++++++++++++-
 5 files changed, 36 insertions(+), 9 deletions(-)

	Gustavo
