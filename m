Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:35907 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZBBOFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 09:05:42 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1485060rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 06:05:41 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18822.64834.288852.590863@gargle.gargle.HOWL> (sfid-20090202_150547_214382_C7AEFDE7)
Date: Mon, 2 Feb 2009 19:33:46 +0530
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jouni.Malinen@atheros.com, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: Extend the rate control API with an update callback
In-Reply-To: <1ba2fa240902020315w49a67afg6ddf8a0e5d367548@mail.gmail.com>
References: <18822.51903.216795.888284@gargle.gargle.HOWL>
	<1ba2fa240902020315w49a67afg6ddf8a0e5d367548@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> I like the idea. It's good for any coexistence  such G protection
> (CTS/RTS) which also affects throughput and RC.
> I'm not sure if it's not better to connect it directly somehow with
> BSS info changed.

The RC algorithm is already notified of G Protection and RTS/CTS through
the RC_USE_* flags. But yeah, it can be extended.

Sujith
