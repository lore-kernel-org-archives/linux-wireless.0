Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3624 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935706Ab1JFOPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 10:15:52 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 6 Oct 2011 07:15:44 -0700
Subject: RE: [PATCH 01/15] staging: brcm80211: move driver variable
 functions to srom.c
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0DC90E6C@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20111006_161556_290215_ECD47ACA)
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
 <1317820814-7083-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1317820814-7083-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Arend van Spriel [mailto:arend@broadcom.com]
> Sent: woensdag 5 oktober 2011 15:20
> 
> The driver uses variables which are stored in string format. Using
> strings as variable identifiers is disliked by the community. The
> driver has been cleaned up and the only module providing these
> variables is srom.c. The variable retrieval functions have been
> moved to srom.c in preparation of a more likable way to store and
> lookup these driver variables.
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Alwin Beukers <alwin@broadcom.com>
> Reviewed-by: Roland Vossen <rvossen@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Well, Greg

And there is the original patch coming out of some hole. Please discard this one.

Gr. AvS


