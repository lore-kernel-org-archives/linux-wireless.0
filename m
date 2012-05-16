Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52431 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2EPQSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 12:18:20 -0400
Received: by obbtb18 with SMTP id tb18so1215529obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2012 09:18:20 -0700 (PDT)
Message-ID: <4FB3D348.2010700@lwfinger.net> (sfid-20120516_181824_581229_6EBD5574)
Date: Wed, 16 May 2012 11:18:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce : freeze after connecting to network with FW Power
 Save on
References: <20120515152951.7cc4f84b@destiny.ordissimo> <4FB26D6B.2030005@lwfinger.net> <20120515170405.7f6510f2@destiny.ordissimo> <4FB28834.4000803@lwfinger.net> <20120516124133.69f57311@destiny.ordissimo>
In-Reply-To: <20120516124133.69f57311@destiny.ordissimo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2012 05:41 AM, Anisse Astier wrote:
> I enabled the following options:
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_LOCKDEP=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> But it didn't detect any lockup yet, and machine still hangs. I'll try
> CONFIG_PROVE_LOCKING.
>
> Enabling CONFIG_DEBUG_INFO seems to make the problem go away...

That may explain why I never see the problem. I do not think I have ever 
generated a kernel with that parameter disabled, and my distro's kernels have it 
enabled. Does anything new get logged (dmesg output) when that parameter is enabled?

Larry
