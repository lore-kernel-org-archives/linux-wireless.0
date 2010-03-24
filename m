Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv4.vsi.ru ([80.82.32.19]:53464 "EHLO serv4.vsi.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab0CXLBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 07:01:38 -0400
Received: from lnv.homelinux.net (76.89.32.95.dsl-dynamic.vsi.ru [95.32.89.76])
	by serv4.vsi.ru (8.13.8+Sun/8.13.8) with ESMTP id o2O971jl023253
	for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 12:07:02 +0300 (MSK)
Received: from nledovskikh.lnv.homelinux.net (nledovskikh.lnv.homelinux.net [192.168.2.2])
	by lnv.homelinux.net (Postfix) with SMTP id 9505317F5A
	for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 12:07:01 +0300 (MSK)
Date: Wed, 24 Mar 2010 12:06:45 +0300
From: =?KOI8-R?Q?=EC=C5=C4=CF=D7=D3=CB=C9=C8_=EE=C9=CB=CF=CC=C1=CA_=F7=C1?=
	 =?KOI8-R?Q?=CC=C5=D2=D8=C5=D7=C9=DE?= <nledovskih@mail.ru>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Mesh mode broken since 2.6.34-rc1
Message-Id: <20100324120645.5b43757c.nledovskih@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh mode does not work any more. I have some x86 MPs with 2.6.33.1, which work fine. 
But there are establishment problems with 2.6.34-rc1. 
The peering status changes between LISTEN, OPN_SNT and HOLDING, but does not reach ESTAB.

-- 
Best regards, Nick.
