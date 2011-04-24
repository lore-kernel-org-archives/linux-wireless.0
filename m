Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:48763 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab1DXS6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 14:58:38 -0400
Received: from [195.4.92.23] (helo=13.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QE4Vx-0002kF-AP
	for linux-wireless@vger.kernel.org; Sun, 24 Apr 2011 20:58:37 +0200
Received: from p54a180da.dip0.t-ipconnect.de ([84.161.128.218]:38670 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QE4Vx-00013i-1K
	for linux-wireless@vger.kernel.org; Sun, 24 Apr 2011 20:58:37 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p3OIwXGh003517
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 20:58:34 +0200
Message-ID: <4DB47349.6000404@01019freenet.de> (sfid-20110424_205841_713404_FDDC6DB6)
Date: Sun, 24 Apr 2011 21:00:25 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] compat: do not include kstrto* for kernel >= 2.6.38.4
References: <1303661475-26632-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1303661475-26632-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens wrote:
> kstrto* went into kernel 2.6.38.4 and causes conflicts with the version
> included in compat-wireless. We use strict_strtol to check if kstrto*
> is already available.
> kstrto* was not moved to compat-2.6.38.h because kernel version <=
> 2.6.38.3 needs this backport and some distributions like Ubuntu still
> ship an older version of this kernel.
> 
> Reported-by: Andreas Hartmann <andihartmann@01019freenet.de>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

The patch works fine - I tested it with compat-wireless-2011-04-23.


Thank you,
kind regards,
Andreas
