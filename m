Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:46935 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996AbZFPVyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 17:54:18 -0400
Received: by gxk10 with SMTP id 10so8264960gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 14:54:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A381159.70301@wpkg.org>
References: <4A381159.70301@wpkg.org>
Date: Tue, 16 Jun 2009 17:54:19 -0400
Message-ID: <b6c5339f0906161454tbdaf382k654450a9f1cf8ae7@mail.gmail.com>
Subject: Re: ath5k AP support?
From: Bob Copeland <me@bobcopeland.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 5:40 PM, Tomasz Chmielewski<mangoo@wpkg.org> wrote:
> According to http://linuxwireless.org/en/users/Drivers/ath5k, AP mode is
> "reported to work, we just need some further tests on all cards to be sure".
>
> I just tried it with 2.6.30 kernel with this card:

2.6.30 does not enable AP mode, you should try the wireless-testing
tree instead.

There is at least one known bug (the patch at the end is broken but
close):  http://bugzilla.kernel.org/show_bug.cgi?id=13237

-- 
Bob Copeland %% www.bobcopeland.com
