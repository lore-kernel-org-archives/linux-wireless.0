Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:54699 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYJNEOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 00:14:22 -0400
Received: by gxk9 with SMTP id 9so4694524gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 21:14:21 -0700 (PDT)
Message-ID: <43e72e890810132114j5ad8a19axc933d90e5b6e17a3@mail.gmail.com> (sfid-20081014_061435_642946_A1A9ABA7)
Date: Mon, 13 Oct 2008 21:14:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com
Subject: Re: [PATCH 0/3] ath5k/ath9k: correct signal quality
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1223932090-9274-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223932090-9274-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 2:08 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

Oops this was supposed to be my description of this series :)

So -- signal quality is reported incorrectly on ath5k and ath9k. This
series corrects that. You can really get creative with more complex
and more accurate solutions but this requires keeping a track of ideal
SNR for best throughput possible for different modes. We use a
simplified calculation based on considerations for an ideal RSSI for
the best rate we support. These values were given by our engineering
team.

   Luis
