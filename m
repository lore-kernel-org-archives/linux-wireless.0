Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37424 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2ENILi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 04:11:38 -0400
Received: by obbtb18 with SMTP id tb18so7100370obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 01:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336982561.4303.10.camel@jlt3.sipsolutions.net>
References: <CAOpc7mEZGZMCCBnnLo-v6ooz4qgKXOeF7kJeb3yzeeV8L-g5bA@mail.gmail.com>
	<1336982561.4303.10.camel@jlt3.sipsolutions.net>
Date: Mon, 14 May 2012 10:11:37 +0200
Message-ID: <CAOpc7mE2BohcwTdeNTfGWcDBPFN0KfV9jaEfj0BC36aDzz6w6A@mail.gmail.com> (sfid-20120514_101142_734261_7361DE3D)
Subject: Re: ath9k: write-only variable rx.rxotherant ?!?!?
From: Holger Schurig <holgerschurig@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ups, I oversaw the ++. I thought only zeros would ever be written there.

/me hides behind a tree
