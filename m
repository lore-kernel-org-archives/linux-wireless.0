Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:61769 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZLAHYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 02:24:15 -0500
Received: by iwn1 with SMTP id 1so2903404iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 23:24:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B0B4405.4050605@gmail.com>
References: <4B0B4405.4050605@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 30 Nov 2009 23:24:02 -0800
Message-ID: <43e72e890911302324x3cc76994r6e9ce17f74dec519@mail.gmail.com>
Subject: Re: [PATCH 08/13] Add compatibility macro for register_sysctl_table()
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 6:25 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> The API was changed on commit 0b4d4147. register_sysctl_table() lost its
> last
> argument.
>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

Thanks, applied up to here fine the rest fail because your mailer line
wrapped after 70 something chars. Can you try resenting 9-on using git
send-email?

  Luis
