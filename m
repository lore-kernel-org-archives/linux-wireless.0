Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:39489 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbZGIQmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 12:42:31 -0400
Received: by yxe26 with SMTP id 26so433811yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 09:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090708114252.GG7199@hash.localnet>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
	 <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com>
	 <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
	 <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
	 <20090707030719.GC7199@hash.localnet>
	 <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
	 <20090708114252.GG7199@hash.localnet>
Date: Thu, 9 Jul 2009 12:42:29 -0400
Message-ID: <6c354a1a0907090942o66c4e1b8ue2c952cf7ed7bf9a@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Jasin Colegrove <j.wholesalesupply@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> BTW, can you (re?)post the "Atheros AR5212 chip found (MAC xxx,
> PHY xxxx)?"
>
What exact information do you want and where can I find it?


> Also at least /net (you can add multiple paths to git bisect).

$git bisect start v2.6.30-rc4 v2.6.29 -- drivers/net net/

Is that what you where hinting at? I wasted a whole day trying to fix
errors in drivers/staging before I was told I could just disable
compilation of staging with one switch. Oh well...
