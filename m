Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34837 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbLVKak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 05:30:40 -0500
Received: by mail-ob0-f172.google.com with SMTP id 18so142051123obc.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2015 02:30:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJL_dMuDXMQYRpDAk9FOnTeA+4vsQARw8028DRrmKeRNeLQzug@mail.gmail.com>
References: <CAJL_dMuDXMQYRpDAk9FOnTeA+4vsQARw8028DRrmKeRNeLQzug@mail.gmail.com>
Date: Tue, 22 Dec 2015 11:30:39 +0100
Message-ID: <CACRpkdZPpULxGM+6ch6G4qjTJhh3VTJzo0TK0K7XNa9a5Dy6Mw@mail.gmail.com> (sfid-20151222_113043_569427_1DC26C13)
Subject: Re: Mediatek wifi
From: Linus Walleij <linus.walleij@linaro.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2015 at 1:09 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:

> https://github.com/neurobin/MT7630E is reported to work for wifi.

Yes this works because it contains a forked and bitrotting copy
of the entire Mediatek code drop including a fork of rt2x00 from
the v3.10 kernel. It's not going to last, and I can't
get it to compile properly with the most recent Fedora kernel
relase (v4.3.x-based).

Ubuntu will also run into the problem sooner or later. :(

Yours,
Linus Walleij
