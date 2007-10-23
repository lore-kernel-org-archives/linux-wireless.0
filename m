Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:59516 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbXJWTFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 15:05:42 -0400
Received: by an-out-0708.google.com with SMTP id b36so213758ana
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 12:05:41 -0700 (PDT)
Message-ID: <43e72e890710231205x1401c1efia68c4344ce78dcf6@mail.gmail.com> (sfid-20071023_200703_062619_A68034F8)
Date: Tue, 23 Oct 2007 15:05:40 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: undo overzealous hunk of "ath5k: avoid oops when..."
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <11931614033102-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <11931614033102-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/07, John W. Linville <linville@tuxdriver.com> wrote:
> The first hunk of "ath5k: avoid oops when ah_capabilities.cap_mode not
> set" was ill-advised.  It can cause the it's loop to abort prematurely.
>
> Signed-off-by: John W. Linville <linville.tuxdriver.com>

Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>

  Luis
