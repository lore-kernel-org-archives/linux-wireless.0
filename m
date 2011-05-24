Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50801 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab1EXOcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 10:32:21 -0400
Received: by fxm17 with SMTP id 17so4693677fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 07:32:20 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Initial automatic channel selection implementation
Date: Tue, 24 May 2011 16:27:48 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
In-Reply-To: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201105241627.49201.helmut.schaa@googlemail.com> (sfid-20110524_163225_189132_C6E34701)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Am Dienstag, 24. Mai 2011 schrieb Luis R. Rodriguez:
> II - Load check:
> 
>   * In addition to the above take into consideration some metric for
> load on the channel: frame count observed

Sounds similar to the busy time information some drivers already report
via "iw wlan0 survey dump", no? Counting frames sounds like a lot of
overhead to me.

Helmut
