Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36584 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbbA3Sis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 13:38:48 -0500
Message-ID: <54CBCFB6.2030003@broadcom.com> (sfid-20150130_193852_149470_5DD74D2B)
Date: Fri, 30 Jan 2015 19:38:46 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
References: <54C6A717.5050804@broadcom.com> <54CBCADA.4050801@broadcom.com> <54CBCE5A.9080404@hauke-m.de>
In-Reply-To: <54CBCE5A.9080404@hauke-m.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/15 19:32, Hauke Mehrtens wrote:
> Or we just backport this version every time:
>
> struct net *get_net_ns_by_fd(int fd)
> {
> 	return ERR_PTR(-EINVAL);
> }
>

I was going for the easy way out over here. Either way is fine by me, 
but is net namespace support can not be properly backported I would say 
got for the version above.

Gr. AvS
