Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63493 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZERBJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 21:09:54 -0400
Received: by fxm2 with SMTP id 2so2969184fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 18:09:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A10A5C0.7090107@erley.org>
References: <4A0FF4FE.1030304@tls-tautenburg.de>
	 <3ace41890905171600i3308f799n2a643e61fd954d4f@mail.gmail.com>
	 <4A10A5C0.7090107@erley.org>
Date: Mon, 18 May 2009 02:09:53 +0100
Message-ID: <3ace41890905171809t6ad0e654jc07b6dd2d4cf6564@mail.gmail.com>
Subject: Re: compile error compat-wireless
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: Bringfried Stecklum <stecklum@tls-tautenburg.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 1:03 AM, Pat Erley <pat-lkml@erley.org> wrote:

> I got this as well, fixed it by adding #include <asm/unaligned.h> to key.c
>
> I have been running compat-wireless for months, so it's not a missing package
> thing, I suspect it's an outdated headers thing.  My system has 2.6.27 headers
> right now.
>
> Pat Erley
>

Hmm, sorry about that. On my system (2.6.29.3-142.fc11.x86_64) no
change is needed to building compat-wireless.
Maybe it is partly with old kernel heades.
