Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63494 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1BGHFz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 02:05:55 -0500
Received: by pzk35 with SMTP id 35so829177pzk.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 23:05:54 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19791.39353.717293.405524@gargle.gargle.HOWL>
Date: Mon, 7 Feb 2011 12:35:29 +0530
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	David.Woodhouse@intel.com, dwmw2@infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Update ar9271.fw
In-Reply-To: <AANLkTimLJepiVQzTaCw7jU_xioyNHdVMogF8tTb5=mrc@mail.gmail.com>
References: <1297057905-2518-1-git-send-email-vnatarajan@atheros.com>
	<19791.38178.247980.202528@gargle.gargle.HOWL>
	<AANLkTimLJepiVQzTaCw7jU_xioyNHdVMogF8tTb5=mrc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> On Mon, Feb 7, 2011 at 12:15 PM, Sujith <m.sujith@gmail.com> wrote:
> > Vivek Natarajan wrote:
> >> * Enable bluetooth coexistence.
> >> * Fix disconnection issue with WEP and TKIP noticed in some APs.
> >
> > Have you increased the ram segment size/offset in this patch ?
> 
> Nope. RAM segment offset has not been changed.

Ok, thanks.

Sujith
