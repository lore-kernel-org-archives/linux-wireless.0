Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:47251 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZFKRII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 13:08:08 -0400
Received: by gxk10 with SMTP id 10so2487756gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 10:08:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <874oumyddk.fsf@litku.valot.fi>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
	 <874oumyddk.fsf@litku.valot.fi>
Date: Thu, 11 Jun 2009 13:08:10 -0400
Message-ID: <b6c5339f0906111008y6e4cdc2cucf0283deb52ca2a5@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/7] wl12xx SDIO interface
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, pierre@ossman.eu, san@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 11:54 AM, Kalle Valo<kalle.valo@iki.fi> wrote:
> Sorry about the mess, I have been sitting on top of the wl1251 patches
> way too long.

No worries, yeah if you rebase them I'll test the result... patch 7 won't
compile in a vanilla tree until the platform stuff is straightened out,
but the rest should be OK for inclusion I think.

-- 
Bob Copeland %% www.bobcopeland.com
