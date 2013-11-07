Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:44422 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3KGUZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 15:25:33 -0500
Received: by mail-we0-f175.google.com with SMTP id t61so1058630wes.20
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 12:25:32 -0800 (PST)
Message-ID: <1383855924.2579.2.camel@canaries32-MCP7A> (sfid-20131107_212624_984459_D9FD139D)
Subject: Re: [PATCH] staging: vt6656: baseband.c clean up BBbVT3184Init
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Nov 2013 20:25:24 +0000
In-Reply-To: <1383765644.3692.3.camel@canaries32-MCP7A>
References: <1383765644.3692.3.camel@canaries32-MCP7A>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 19:20 +0000, Malcolm Priestley wrote:
> White space clean up and remove camel case from variables.
> 
> pDevice-> priv
> ntStatus -> status
> wLength ->length
> pbyAddr -> addr
> pbyAgc -> agc
> wLengthAgc ->length_agc
> abyArray -> array
> 

Can you please drop this patch.

A long standing critical bug has been found in BBbVT3184Init
that needs to be passed back to stable.

I will redo this patch.

Thanks

Malcolm

