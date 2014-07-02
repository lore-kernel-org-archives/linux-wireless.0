Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36966 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaGBWGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 18:06:43 -0400
Received: by mail-la0-f50.google.com with SMTP id pv20so7377159lab.23
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2014 15:06:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1404302531-18132-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1404302531-18132-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 2 Jul 2014 15:06:22 -0700
Message-ID: <CAB=NE6WN=6cu1rfHjLV32bvwAY6tnW9wrpVx5WHfdu0SJMvC0A@mail.gmail.com> (sfid-20140703_000648_406670_48BE66D3)
Subject: Re: [PATCH] crda: db2rd, parse/print CAC time
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 2, 2014 at 5:02 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> db2rd, parse and print DFS CAC time
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>


This doesn't print the DFS CAC if its a in a line like this:

(5250 - 5330 @ 0), (20), (60000), DFS, AUTO-BW

  Luis
