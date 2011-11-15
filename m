Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:40320 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752307Ab1KOGou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Nov 2011 01:44:50 -0500
Received: by mail-bw0-f52.google.com with SMTP id s6so1147045bka.39
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 22:44:49 -0800 (PST)
Subject: Re: [RFC 00/18] ath9k: Add support for MCI BT coex
From: Luciano Coelho <coelho@ti.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>
In-Reply-To: <1321336840-12366-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1321336840-12366-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 08:44:45 +0200
Message-ID: <1321339485.2408.85.camel@cumari> (sfid-20111115_074454_219844_BEFAFAFB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

On Tue, 2011-11-15 at 11:30 +0530, Mohammed Shafi Shajakhan wrote: 
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> Add support for MCI BT-Coex for AR9462. with AR9462 we have
> WLAN and BT coexists via MCI protocol(Message Coexistence Interface)
> WLAN and BT exchanges GPM, SCHED messages and few other messages
> for coexistence.
> 
> this is not yet tested and need some more review, few misc cleanups. 
> please add your review comments. 
> 
> thanks a lot to Rajkumar Manoharan <rmanohar@qca.qualcomm.com> for
> his suggestions, review comments, code cleanups, and modifications 
> in design. 

[...]

Your patch emails are not being sent in a threaded form, which is a bit
annoying.  Can you fix it? Maybe you are using --no-thread or you have
sendemail.thread set to false in your .gitconfig?

-- 
Cheers,
Luca.

