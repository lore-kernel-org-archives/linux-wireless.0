Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33083 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3CRSaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 14:30:00 -0400
Received: by mail-ob0-f176.google.com with SMTP id v19so5649071obq.21
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 11:29:58 -0700 (PDT)
Message-ID: <51475D23.70108@lwfinger.net> (sfid-20130318_193007_102942_E296AE36)
Date: Mon, 18 Mar 2013 13:29:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: vishnu <vishnu.kopparapu@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: problem connecting to AP on new kernel (disassociating continuously
 after associating ) . Can some one please comment on the issue I am facing
References: <loom.20130315T140953-940@post.gmane.org> <5144A184.1060900@iki.fi> <loom.20130318T191350-236@post.gmane.org>
In-Reply-To: <loom.20130318T191350-236@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2013 01:20 PM, vishnu wrote:
>
> Hello Jussi,
>
> I have applied the patch to kernel 3.7.8 and it doesn't fix my issue. I have
> started testing the latest 3.9.0-rc2 version. I will let you know once I have
> tested.

Please be aware that the patch is not in 3.9-rc2 from Linus's git tree (yet), 
but it is in the wireless-testing git repo.

Larry


