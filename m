Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:35409 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZF3QVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 12:21:13 -0400
Received: by gxk26 with SMTP id 26so368278gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 09:21:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A49EEC3.3060108@mrs.ro>
References: <4A49EEC3.3060108@mrs.ro>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Jun 2009 09:20:56 -0700
Message-ID: <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com>
Subject: Re: mac80211 and broadcast frames
To: Valentin Manea <linux-wireless@mrs.ro>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 3:53 AM, Valentin Manea<linux-wireless@mrs.ro> wrote:
> Hi,
>
>   I've been working on a small project that basically sends broadcast UDP
> frames from an Wireless AP to multiple clients. While I can send UDP frames
> just fine from the AP to the client the only a few broadcast frames reach my
> client. What is really puzzling is that on the client machine using tcpdump
> I can see all the broadcast frames arriving, my application sees only a
> small fraction of them.

Keep in mind when you use tcpdump it will modify the RX filters of the
device you use but if you say you see them on tcpdump and at the same
time do not see them on the application that seems fishy and non
driver related.

  Luis
