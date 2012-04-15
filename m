Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:53167 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab2DOReP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 13:34:15 -0400
Received: by qafi31 with SMTP id i31so8228203qaf.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 10:34:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120413142352.3b927516@destiny.ordissimo>
References: <20120413142352.3b927516@destiny.ordissimo>
From: Anisse Astier <anisse@astier.eu>
Date: Sun, 15 Apr 2012 19:33:54 +0200
Message-ID: <CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com> (sfid-20120415_193419_183018_1120268E)
Subject: Re: RT5390 not working with rt2800pci
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 13, 2012 at 2:23 PM, Anisse Astier <anisse@astier.eu> wrote:
>
> [1] I have many of both, in RT5390(rev 1502) and RT5390F(rev 0502) models. All non working are rev 1502, even if some rev 1502 are working.

To clarify, Revs 0502, marked RT5390L are all working, and can be
ignored for the purpose of this discussion.

The only non-working revs are 1502, which is the model marked
"RT5390RL". This model has zero google results apart from this
discussion, so I'm guessing it might be new, hence not much tested and
not supported.

Why some cards work and others don't is a mystery.

--
Anisse
