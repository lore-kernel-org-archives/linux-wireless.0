Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224Ab2FASQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 14:16:31 -0400
Date: Fri, 1 Jun 2012 13:16:25 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 05/10] brcm80211: smac: remove DFS channels from 5GHz band
Message-ID: <20120601181625.GA31517@thinkpad-t410> (sfid-20120601_201634_908846_8F03F430)
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
 <1338567336-12076-6-git-send-email-seth.forshee@canonical.com>
 <2D7FF7D769509245B7AD0DB511D0FD3A17AB30@SJEXCHMB09.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2D7FF7D769509245B7AD0DB511D0FD3A17AB30@SJEXCHMB09.corp.ad.broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 01, 2012 at 05:52:55PM +0000, Brett Rudley wrote:
> 
> Not quite understanding this. Why does a STA need radar detection when the NO_IBSS flag is set?

Arend specifically suggested removing these channels due to lack of DFS
support [1]. I replied asking whether it was at least possible to detect
radar presence and stop transmitting in order to be able to use these
channels. The last response from Arend was that he was going to check on
the firmware capabilities.

I'm more than happy to drop this patch if there's not regulatory
impedement to operating on the DFS channels.

[1] http://www.spinics.net/lists/linux-wireless/msg91022.html

