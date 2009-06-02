Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:42803 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZFBU5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:57:20 -0400
Received: by gxk10 with SMTP id 10so14706670gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2009 13:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243974656-15600-1-git-send-email-lrodriguez@atheros.com>
References: <1243974656-15600-1-git-send-email-lrodriguez@atheros.com>
Date: Tue, 2 Jun 2009 16:57:22 -0400
Message-ID: <b6c5339f0906021357y14c64003lbbfaa0744ced7617@mail.gmail.com>
Subject: Re: [PATCH] ath: make regulatory parsing more verbose on debug
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2009 at 4:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This should help when reviewing issues regarding regulatory
> domain on ath5k/ath9k/ar9170.

i.e. code is too complicated to reason about :)

> +       printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);

definite ACK on that at least...

-- 
Bob Copeland %% www.bobcopeland.com
