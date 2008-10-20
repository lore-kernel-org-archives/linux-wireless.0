Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:4893 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYJTXKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 19:10:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so357093ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 16:10:41 -0700 (PDT)
Message-ID: <43e72e890810201610r51145727l4e1dfb9d705d777d@mail.gmail.com> (sfid-20081021_011046_821921_5198D155)
Date: Mon, 20 Oct 2008 16:10:40 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Evgeni Golov" <sargentd@die-welt.net>
Subject: Re: [PATCH] crda: Fix the keys-gcrypt.c target and remove key.priv.pem on clean
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081020160138.C73681FD14@chi.die-welt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081020160138.C73681FD14@chi.die-welt.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 9:01 AM, Evgeni Golov <sargentd@die-welt.net> wrote:
> Hi,
>
> while trying to build CRDA I noticed, that key.priv.pem isn't
> removed on clean. After patching this, CRDA stopped building with
> *** No rule to make target `*.pem', needed by `keys-gcrypt.c'. Stop.
> The keys-gcrypt.c target needed the same wildcard *.pem handling as the
> keys-ssl.c target.
> Patch against current crda git HEAD is attached.

Thanks applied, please send other patches inline if possible.

  Luis
