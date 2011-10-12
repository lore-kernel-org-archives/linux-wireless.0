Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4658 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab1JLTVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 15:21:06 -0400
Message-ID: <4E95E897.8090709@broadcom.com> (sfid-20111012_212111_317624_6FC253E6)
Date: Wed, 12 Oct 2011 21:20:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Alwin Beukers" <alwin@broadcom.com>
Subject: Re: [PATCH 22/22] brcm80211: removed file wifi.c
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
 <1318445492-24207-23-git-send-email-arend@broadcom.com> (
 sfid-20111012_205231_795177_8B760EF6)
 <1318446818.3933.45.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318446818.3933.45.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2011 09:13 PM, Johannes Berg wrote:
> On Wed, 2011-10-12 at 20:51 +0200, Arend van Spriel wrote:
> 
>> -#include <brcmu_wifi.h>
> 
> Does that header file have any content left?
> 
> johannes
> 
> 

It has, but we intend to get rid of brcmutil although the pktq functions
are giving me a headache or it is due to the cold I caught.

Gr. AvS

