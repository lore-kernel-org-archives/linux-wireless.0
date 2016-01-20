Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20312 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbcATVxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 16:53:33 -0500
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
To: Johannes Berg <johannes@sipsolutions.net>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
 <1452678583-20086-3-git-send-email-arend@broadcom.com>
 <1452769832.2444.14.camel@sipsolutions.net> <569CB190.1000901@broadcom.com>
 <1453209647.3896.22.camel@sipsolutions.net> <569EB9A6.4030808@broadcom.com>
 <1453298541.13263.10.camel@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Ilan Peer <ilan.peer@intel.com>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <56A001DA.9010400@broadcom.com> (sfid-20160120_225342_221279_AA3AE92E)
Date: Wed, 20 Jan 2016 22:53:30 +0100
MIME-Version: 1.0
In-Reply-To: <1453298541.13263.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 20-1-2016 15:02, Johannes Berg wrote:
> Ilan pointed me to this:
> 
> http://androidxref.com/6.0.1_r10/xref/hardware/libhardware_legacy/include/hardware_legacy/gscan.h#351
> 
> 
> I'd say that would just be a separate primitive, and then Android would
> pick that in some way?

It was not part of my plan, but it seems to fit, yes. Android now uses
vendor command with google oui for gscan if I am not mistaken.

Regards,
Arend
