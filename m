Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:35655 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0FWMmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 08:42:55 -0400
Message-ID: <4C22014A.3000102@bu3sch.de>
Date: Wed, 23 Jun 2010 14:42:50 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Recent results with BCM4312 on Netbook
References: <4C20D884.3010501@lwfinger.net> <AANLkTikjzHcT9L472CFJ2LKtOiEUIk2S78_S_s-IxHjl@mail.gmail.com> (sfid-20100623_004823_485864_1D673701)
In-Reply-To: <AANLkTikjzHcT9L472CFJ2LKtOiEUIk2S78_S_s-IxHjl@mail.gmail.com> (sfid-20100623_004823_485864_1D673701)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please note that there were some rewrites recently in the kernel
DMA subsystem. b43 does now use the generic DMA interface, which
should work on all busses. I would not rule out an error in
that area, though it's unlikely.

-- 
Greetings Michael.
