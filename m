Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35784 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab1CGCgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:36:03 -0500
Received: by vws12 with SMTP id 12so3355682vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:36:02 -0800 (PST)
Message-ID: <4D74448E.2070504@lwfinger.net>
Date: Sun, 06 Mar 2011 20:35:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?=
	<francois.valenduc@tvcablenet.be>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 11/11] rtlwifi: rtl8192se: Modify rtlwifi routines to
 handle rtl8192se and add Makefile and Kconfig
References: <4d732b88.lM+a0Gg928N+S/xO%Larry.Finger@lwfinger.net> <4D73EB12.3040102@tvcablenet.be> <4D73F209.8050406@lwfinger.net> <4D73F506.50609@tvcablenet.be>
In-Reply-To: <4D73F506.50609@tvcablenet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2011 02:56 PM, François Valenduc wrote:

> Sorry to annoy you again but either I am doing something wrong or this
> new patch doesn't apply on top of the 10 first patches. There seems to
> be problems in fuse.c, pci.c and core.c (all in
> drivers/net/wireless/rtlwifi).

Did the driver build for you after those other two patches were added?

What are the PCI IDs for your device? I have 3 of them, and one does not yet 
work - a problem that I'm now chasing.

Larry
