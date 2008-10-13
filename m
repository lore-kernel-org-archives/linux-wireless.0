Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:31486 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbYJMWCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:02:49 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1175559wri.5
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 15:02:47 -0700 (PDT)
Message-ID: <43e72e890810131502r1df02b37wfdae209fdbc1631b@mail.gmail.com> (sfid-20081014_000253_432441_608853F2)
Date: Mon, 13 Oct 2008 15:02:47 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Cameron Hutchison" <lists@xdna.net>
Subject: Re: [ath9k-devel] Failed to init on TP-Link TL-WN861N
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810131500u289f6e4fwf380966ae8f40b7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <667b.48f192b0.3a106@getafix.xdna.net>
	 <43e72e890810131500u289f6e4fwf380966ae8f40b7b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 3:00 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> In
> your case we tried writing to register offset 0x8000 the value
> 0x00ff00ff but read 0x00ff00ef, this test will only continue if the
> value read was 0x00ff00ef

I meant 0x00ff00ff of course.

  Luis
