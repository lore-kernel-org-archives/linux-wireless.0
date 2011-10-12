Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1JLT26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 15:28:58 -0400
Subject: Re: [PATCH 22/22] brcm80211: removed file wifi.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Alwin Beukers <alwin@broadcom.com>
In-Reply-To: <4E95E897.8090709@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
	 <1318445492-24207-23-git-send-email-arend@broadcom.com>
	 ( sfid-20111012_205231_795177_8B760EF6) <1318446818.3933.45.camel@jlt3.sipsolutions.net>
	 <4E95E897.8090709@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 21:28:52 +0200
Message-ID: <1318447732.3933.48.camel@jlt3.sipsolutions.net> (sfid-20111012_212914_335559_331856DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-12 at 21:20 +0200, Arend van Spriel wrote:
> On 10/12/2011 09:13 PM, Johannes Berg wrote:
> > On Wed, 2011-10-12 at 20:51 +0200, Arend van Spriel wrote:
> > 
> >> -#include <brcmu_wifi.h>
> > 
> > Does that header file have any content left?
> > 
> > johannes
> > 
> > 
> 
> It has, but we intend to get rid of brcmutil 

Ok, I didn't check :)

> although the pktq functions
> are giving me a headache or it is due to the cold I caught.

Oh. Hope you feel better soon!

johannes

