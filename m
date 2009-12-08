Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:37693 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966589AbZLHWo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:44:27 -0500
MIME-Version: 1.0
In-Reply-To: <20091208073542.GC22204@atheros-laptop>
References: <20091208073542.GC22204@atheros-laptop>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 9 Dec 2009 09:44:14 +1100
Message-ID: <646765f40912081444t64d94ac3k9bcea8b5296a9591@mail.gmail.com>
Subject: Re: [PATCH] Added compat-bluetooth to compat-wireless-2.6
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 8, 2009 at 18:35, Bala Shanmugam <sbalashanmugam@atheros.com> wrote:
>
> Added compat-bluetooth to compat-wireless-2.6
>
> Added new scripts to load and unload wireless
> and bluetooth modules seperately.
>
> Compat is compiled as separate kernel module as
> both wireless and bluetooth modules require it.
>
> Compat Bluetooth has support to compile latest bluetooth code
> for kernel versions 2.6.27 to 2.6.31.

Should all this new functionality be documented in the README document?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
