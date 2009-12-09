Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41166 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZLIMF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 07:05:29 -0500
Received: by fxm5 with SMTP id 5so7385067fxm.28
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 04:05:35 -0800 (PST)
Message-ID: <4B1F928D.6050000@gmail.com>
Date: Wed, 09 Dec 2009 13:05:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: useless ath9k commit logs
References: <4B1F76F2.4090004@gmail.com> <19231.35710.80659.717664@gargle.gargle.HOWL>
In-Reply-To: <19231.35710.80659.717664@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2009 12:35 PM, Sujith wrote:
> This is also a bug fix. Rate control gets bumpy when switching between
> APs operating in different modes. This was identified by internal testing.
> 
> Hope this helps.

Ah, thanks, there are many of them though, these were just examples.
Please add such a description to each changelog from now on. I think
many kernel distro packagers will appreciate that.

thanks again,
-- 
js
