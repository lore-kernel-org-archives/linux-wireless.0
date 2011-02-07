Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52613 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1BGGuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 01:50:07 -0500
Received: by wwa36 with SMTP id 36so4462607wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 22:50:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19791.38178.247980.202528@gargle.gargle.HOWL>
References: <1297057905-2518-1-git-send-email-vnatarajan@atheros.com>
	<19791.38178.247980.202528@gargle.gargle.HOWL>
Date: Mon, 7 Feb 2011 12:20:06 +0530
Message-ID: <AANLkTimLJepiVQzTaCw7jU_xioyNHdVMogF8tTb5=mrc@mail.gmail.com>
Subject: Re: [PATCH] Update ar9271.fw
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	David.Woodhouse@intel.com, dwmw2@infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 7, 2011 at 12:15 PM, Sujith <m.sujith@gmail.com> wrote:
> Vivek Natarajan wrote:
>> * Enable bluetooth coexistence.
>> * Fix disconnection issue with WEP and TKIP noticed in some APs.
>
> Have you increased the ram segment size/offset in this patch ?

Nope. RAM segment offset has not been changed.

Vivek.
