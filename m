Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:60827 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3K3Ng1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 08:36:27 -0500
Received: by mail-ve0-f177.google.com with SMTP id db12so7466229veb.22
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 05:36:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385817282.5056.0.camel@jlt4.sipsolutions.net>
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
 <1385817282.5056.0.camel@jlt4.sipsolutions.net>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Sat, 30 Nov 2013 17:36:06 +0400
Message-ID: <CAHNKnsSZxMscirbW=BqTa7fPXDUeFp67Co=QEtawjSOmctfs9Q@mail.gmail.com> (sfid-20131130_143631_270382_DB14B26A)
Subject: Re: wireless network interfaces and network namespaces
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kevin Wilson <wkevils@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/30 Johannes Berg <johannes@sipsolutions.net>:
> having different virtual interfaces of the same NIC in different
> namespaces is not supported.
>
Is this rule applicable to hwsim interfaces too?

-- 
BR,
Sergey
