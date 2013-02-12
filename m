Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57941 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153Ab3BLTxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:53:04 -0500
Received: by mail-ob0-f169.google.com with SMTP id ta14so479312obb.28
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 11:53:01 -0800 (PST)
Message-ID: <511A9D9B.7070804@lwfinger.net> (sfid-20130212_205309_853535_2335DF79)
Date: Tue, 12 Feb 2013 13:52:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John W Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Rework Kconfig
References: <511a9bbf.62vWRaboLfIa29ND%Larry.Finger@lwfinger.net>
In-Reply-To: <511a9bbf.62vWRaboLfIa29ND%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2013 01:45 PM, Larry Finger wrote:
> #
> # For a description of the syntax of this configuration file,
> # see Documentation/kbuild/kconfig-language.txt.
> #
> mainmenu "Linux/$ARCH $KERNELVERSION Kernel Configuration"
>
> config SRCARCH
> 	string
> 	option env="SRCARCH"
>
> source "arch/$SRCARCH/Kconfig"

In case there is any confusion, this is garbage and resulted from an operator 
problem. The other E-mail with the same subject is correct.

Larry


