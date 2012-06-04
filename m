Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760416Ab2FDNTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 09:19:15 -0400
Date: Mon, 4 Jun 2012 08:19:09 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 05/10] brcm80211: smac: remove DFS channels from 5GHz band
Message-ID: <20120604131909.GA18673@thinkpad-t410> (sfid-20120604_151932_207023_278C5F04)
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
 <1338567336-12076-6-git-send-email-seth.forshee@canonical.com>
 <2D7FF7D769509245B7AD0DB511D0FD3A17AB30@SJEXCHMB09.corp.ad.broadcom.com>
 <20120601181625.GA31517@thinkpad-t410>
 <4FCBCCFC.7000905@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FCBCCFC.7000905@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 03, 2012 at 10:45:48PM +0200, Arend van Spriel wrote:
> On 06/01/2012 08:16 PM, Seth Forshee wrote:
> > On Fri, Jun 01, 2012 at 05:52:55PM +0000, Brett Rudley wrote:
> >>
> >> Not quite understanding this. Why does a STA need radar detection when the NO_IBSS flag is set?
> > 
> > Arend specifically suggested removing these channels due to lack of DFS
> > support [1]. I replied asking whether it was at least possible to detect
> > radar presence and stop transmitting in order to be able to use these
> > channels. The last response from Arend was that he was going to check on
> > the firmware capabilities.
> 
> I did not follow up with you, but I exchanged some emails with Brett on
> this. As brcmsmac does not support AP mode (yet) it does not need radar
> detection. Detection and appropriate action is coordinated by the AP.
> 
> > I'm more than happy to drop this patch if there's not regulatory
> > impedement to operating on the DFS channels.
> > 
> 
> Let's drop it then. Sorry for not informing you sooner. I will have a
> look at the other patches as well.

No problem. I dropped the patch locally on Friday and have been running
with it over the weekend. I'll wailt a bit longer before resending to
see if you notice anything else that should be changed.

Seth

