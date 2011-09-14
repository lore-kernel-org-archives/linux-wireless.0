Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3648 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab1INHFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 03:05:11 -0400
Message-ID: <4E70521B.6050801@broadcom.com> (sfid-20110914_090516_202298_8E0D079D)
Date: Wed, 14 Sep 2011 09:04:59 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 14/17] staging: brcm80211: simplification of
 brcmf_netdev_ioctl_priv()
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
 <1315900197-7260-15-git-send-email-rvossen@broadcom.com>
 <20110914020124.GB7002@shale.localdomain>
In-Reply-To: <20110914020124.GB7002@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +	if (ioc->buf != NULL)
>> +		buflen = min_t(int, ioc->len, BRCMF_IOCTL_MAXLEN);
>                                ^^^^
> Should be uint here.

You are right. Greg, please drop [14/17], I will post a v2 patch.

Thanks, Roland.

