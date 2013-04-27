Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42110 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3D0SvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 14:51:07 -0400
Received: by mail-wi0-f174.google.com with SMTP id m6so1606570wiv.7
        for <linux-wireless@vger.kernel.org>; Sat, 27 Apr 2013 11:51:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367087995-8960-1-git-send-email-linux@rempel-privat.de>
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de>
	<1367087995-8960-1-git-send-email-linux@rempel-privat.de>
Date: Sat, 27 Apr 2013 11:51:05 -0700
Message-ID: <CAJ-VmonF9XaVZ6MkP-T3cdfGNjXaroM-rXYcA=TUndicp77UnQ@mail.gmail.com> (sfid-20130427_205123_564635_212261C9)
Subject: Re: [PATCH v2] ath9k: collect statistics about Rx-Dup and Rx-STBC packets
From: Adrian Chadd <adrian@freebsd.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

Why not just bump rs_flags to be a u16, rather than a u8? then you
don't need an rs_flags_2.

(And then go and re-align things inside that struct so you don't waste space.)



Adrian
