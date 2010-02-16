Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f187.google.com ([209.85.222.187]:43466 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933273Ab0BPTyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 14:54:41 -0500
Received: by pzk17 with SMTP id 17so5411846pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 11:54:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <-5494603506932359470@unknownmsgid>
References: <-5494603506932359470@unknownmsgid>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 16 Feb 2010 11:54:19 -0800
Message-ID: <43e72e891002161154pea92815gc3ee2a252d52b4eb@mail.gmail.com>
Subject: Re: [PATCH 1/3] compat-wireless-stable-2.6.33.y: Activate ssb
To: y@hauke-m.de
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 1, 2010 at 2:25 PM,  <y@hauke-m.de> wrote:
> From: Hauke Mehrtens <hauke@hauke-m.de>
>
> This is a backport of compat-wireless commit 67228098e77852a0cf50c7c6c413fa601bd6f5b1

Sorry, not sure why I missed this, thanks for the poke. Applied and
pushed. Will generate a tarball for compat-wireless-2.6.33 after
testing compilation against 2.6.27.

  Luis
