Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:40219 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZFRGBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 02:01:39 -0400
Received: by gxk10 with SMTP id 10so1385630gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 23:01:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245302612-18112-4-git-send-email-vasanth@atheros.com>
References: <1245302612-18112-1-git-send-email-vasanth@atheros.com>
	<1245302612-18112-2-git-send-email-vasanth@atheros.com> <1245302612-18112-3-git-send-email-vasanth@atheros.com>
	<1245302612-18112-4-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 17 Jun 2009 23:01:21 -0700
Message-ID: <43e72e890906172301x2dc2a4abp26e504617a7a1219@mail.gmail.com>
Subject: Re: [PATCH 4/4] ath9k: Nuke struct ath_tx_ratectrl_state
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2009 at 10:23 PM, Vasanthakumar
Thiagarajan<vasanth@atheros.com> wrote:
> Move its only member (u8 per) to struct ath_rate_priv.

yay! BTW are these based on top of my rate series?

 Luis
