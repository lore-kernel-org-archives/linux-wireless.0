Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35461 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZLVDhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 22:37:54 -0500
Received: by yxe17 with SMTP id 17so5507954yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 19:37:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091222022135.2102c465@magooz.no-ip.org>
References: <20091222022135.2102c465@magooz.no-ip.org>
Date: Mon, 21 Dec 2009 22:37:51 -0500
Message-ID: <b6c5339f0912211937o525c9117k2e6d877b3c91b858@mail.gmail.com>
Subject: Re: [PATCH] ath5k: adding LED support for AR5BXB63 cards
From: Bob Copeland <me@bobcopeland.com>
To: Luca Verdesca <magooz@salug.it>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 8:21 PM, Luca Verdesca <magooz@salug.it> wrote:
> With following patch, LED should now work with LiteOn AR5BXB63 mini
> pci-e cards.
>
> I hope I made no mistake.
>
> Happy hacking!
> Magooz

Would you mind re-spinning a patch using the subvendor instead of the
Atheros device ID?  For all I know, all of the AR5BXB63s are the same,
but just in case let's stick with subvendor until we know for sure.
You can get the proper numbers by running lspci -vnn as root, and look
at the other stanzas for examples.

Thanks!
-Bob

-- 
Bob Copeland %% www.bobcopeland.com
