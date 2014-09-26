Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63920 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbaIZNcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 09:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140926122207.GA27809@redhat.com>
References: <5424566B.6000206@gmail.com>
	<20140926122207.GA27809@redhat.com>
Date: Fri, 26 Sep 2014 09:32:18 -0400
Message-ID: <CAAxn8J=gKVdNt3+Ayx-XdEki7V8sg-M7C=kK7sGADBO3L-PTQw@mail.gmail.com> (sfid-20140926_153250_682530_FCFD71C7)
Subject: Re: FIXMEs in rt2800lib.c
From: Nicholas Krause <yocto6@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ivo Van Doorn <IvDoorn@gmail.com>, helmut.schaa@googlemail.com,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org,
	"julia.lawall@lip6.fr oneukum@suse.de" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2014 at 8:22 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Sep 25, 2014 at 01:52:43PM -0400, nick wrote:
>> I seem to be hitting to fix mes in the file I listed in the subject. Would someone tell me if it's Ok to remove
>> the lines that over write certain registers.
>
> No, as long you prove that they are not needed.
>
> Stanislaw
Sure Stanislw,
I will remove the lines as needed and send it a patch.
Nick
