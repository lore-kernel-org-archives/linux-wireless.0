Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:24456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab0JNEXF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 00:23:05 -0400
Message-ID: <4CB685A4.8030301@Atheros.com>
Date: Thu, 14 Oct 2010 09:53:00 +0530
From: Suraj Sumangala <suraj@Atheros.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Kevin Hayes <kevin@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	Suraj Sumangala <Suraj.Sumangala@Atheros.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Firmware versioning best practices: ath3k-2.fw rename or replace
 ath3k-1.fw ?
References: <20101008170258.GJ10149@tux> <4CAF5488.3030706@Atheros.com> <20101008181508.GM10149@tux> <20101012211726.GE2678@broadcom.com> <1286964370.3316.6.camel@aeonflux> <AANLkTimAeoS2Vi7GhKSTrghqaOQ=XKSzjcou15dn+YDR@mail.gmail.com> <B7132A25476D334D9130FE7532F2A56314B5929629@SC1EXMB-MBCL.global.atheros.com> <AANLkTik9oYwspVG4KFbMMq63SpBp++iZe=vxOSQhxRki@mail.gmail.com>
In-Reply-To: <AANLkTik9oYwspVG4KFbMMq63SpBp++iZe=vxOSQhxRki@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On 10/13/2010 11:39 PM, Luis R. Rodriguez wrote:
> Does HCI support uploading firmware? Can't we resolve this blacklist
> crap issue if devices just used HCI to upload firmware?

HCI does not support uploading firmware. But HCI does provide options 
for vendor specific commands that can be used for uploading firmware as 
long as your device has enough intelligence to understand the command 
when it comes.

This is what we do for AR300x serial devices. We do not download 
firmware,  but we do download all configuration entries as VS HCI commands.
>
>    Luis

Regards
Suraj
