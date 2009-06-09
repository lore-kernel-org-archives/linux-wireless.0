Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:38081 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZFIOTf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:19:35 -0400
Message-ID: <4A2E6F75.5070802@lwfinger.net>
Date: Tue, 09 Jun 2009 09:19:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH, RFC] b43: Add fw capabilities
References: <200904080211.16298.mb@bu3sch.de> <200906082105.00868.s.L-H@gmx.de> <200906091554.45182.mb@bu3sch.de>
In-Reply-To: <200906091554.45182.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> From: Michael Buesch <mb@bu3sch.de>
> 
>> Subject: [PATCH, RFC] b44: Add fw capabilities
>>
>>  Completely untested patch to implement firmware capabilities
>>  and automagic QoS-disabling.
>>
> 
> Add automagic feature flags, so the firmware can tell the driver
> about supported features and the driver can switch features on/off as needed.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---

