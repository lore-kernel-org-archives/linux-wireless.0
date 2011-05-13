Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout8.freenet.de ([195.4.92.98]:59310 "EHLO mout8.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab1EMVe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 17:34:59 -0400
Received: from [195.4.92.18] (helo=8.mx.freenet.de)
	by mout8.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QL00f-0007tl-0F
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 23:34:57 +0200
Received: from p54a1954a.dip0.t-ipconnect.de ([84.161.149.74]:46891 helo=mail.maya.org)
	by 8.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QL00e-0002vH-MT
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 23:34:56 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p4DLYsWU002951
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 23:34:55 +0200
Message-ID: <4DCDA3FA.2030007@01019freenet.de> (sfid-20110513_233504_334969_BCD763EE)
Date: Fri, 13 May 2011 23:34:50 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Regression] Kernel panic with ath9k
References: <BANLkTi=9MWn8EWKD0-nFawNnfyEyMDT9sQ@mail.gmail.com>
In-Reply-To: <BANLkTi=9MWn8EWKD0-nFawNnfyEyMDT9sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

well, there is really something broken with compat-wireless-2011-05-11.
On 2.6.34 and rt2800pci, my machine crashed meanwhile 3 times always
after the first wlan machine was authenticated. Unfortunately, I do not
have any trace, because the machine always was locked up hard.

compat-wireless-2011-05-05 does work fine.


Regards,
Andreas
