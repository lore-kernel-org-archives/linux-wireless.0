Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4200 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1GVJhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 05:37:46 -0400
Message-ID: <4E2944DA.5070507@broadcom.com> (sfid-20110722_113749_515825_03548031)
Date: Fri, 22 Jul 2011 11:37:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/19] checkpatch changes and brcmfmac cleanup
References: <4E294123.8040504@broadcom.com>
In-Reply-To: <4E294123.8040504@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Subject: [PATCH 00/19] checkpatch changes and brcmfmac cleanup
> Date: Mon, 18 Jul 2011 07:29:46 -0700
> From: Arend van Spriel<arend@broadcom.com>
> To: gregkh@suse.de<gregkh@suse.de>
> CC: Arend Van Spriel<arend@broadcom.com>,
> "linux-wireless@vger.kernel.org"	<linux-wireless@vger.kernel.org>,
> "devel@linuxdriverproject.org"	<devel@linuxdriverproject.org>
>
> This series removes several checkpatch errors and warnings in the
> drivers and several cleanup changes in brcmfmac driver.

Hi Greg,

Intended to add some dependency info but forgot. Using the format 
suggested by Dan Carpenter, here it is:

This series applies to staging-next with the following patch set applied:

Message-ID:<1310678971-28952-1-git-send-email-frankyl@broadcom.com>
*excluding* Message-ID:<1310678971-28952-36-git-send-email-frankyl@broadcom.com>


Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


