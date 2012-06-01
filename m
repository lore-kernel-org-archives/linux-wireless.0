Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3666 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933623Ab2FASic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 14:38:32 -0400
From: "Brett Rudley" <brudley@broadcom.com>
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: RE: [PATCH 05/10] brcm80211: smac: remove DFS channels from
 5GHz band
Date: Fri, 1 Jun 2012 18:38:20 +0000
Message-ID: <2D7FF7D769509245B7AD0DB511D0FD3A17AD15@SJEXCHMB09.corp.ad.broadcom.com> (sfid-20120601_203836_349030_2728D7AD)
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
 <1338567336-12076-6-git-send-email-seth.forshee@canonical.com>
 <2D7FF7D769509245B7AD0DB511D0FD3A17AB30@SJEXCHMB09.corp.ad.broadcom.com>
 <20120601181625.GA31517@thinkpad-t410>
In-Reply-To: <20120601181625.GA31517@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, Jun 01, 2012 at 05:52:55PM +0000, Brett Rudley wrote:
> >
> > Not quite understanding this. Why does a STA need radar detection when
> the NO_IBSS flag is set?
> 
> Arend specifically suggested removing these channels due to lack of DFS
> support [1]. I replied asking whether it was at least possible to detect
> radar presence and stop transmitting in order to be able to use these
> channels. The last response from Arend was that he was going to check on
> the firmware capabilities.

Our ucode refrains from transmitting in the absence of all other 802.11 traffic on 5 Ghz channels.

> I'm more than happy to drop this patch if there's not regulatory impedement to operating on the DFS channels.

Please.

Thanks
Brett


