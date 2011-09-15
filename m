Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1096 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403Ab1IOPRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 11:17:00 -0400
Message-ID: <4E7216E0.9000303@broadcom.com> (sfid-20110915_171704_881182_9F88ECE0)
Date: Thu, 15 Sep 2011 17:16:48 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/17] staging: brcm80211: remove ioctl layer from
 brcmsmac
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
 <1315900197-7260-3-git-send-email-rvossen@broadcom.com>
 <20110913191419.GA7002@shale.localdomain>
In-Reply-To: <20110913191419.GA7002@shale.localdomain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg, please drop this particular [02/17] patch. I will send a new one.

Hello Dan,

>> +		if (!error)
>                      ^^^^^^
> This test is reversed so this will fill your log with spam.

You are right. Will sent out a new patch today.

Thanks for the sharp eye,

Roland.

