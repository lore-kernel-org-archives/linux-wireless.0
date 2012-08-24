Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33301 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab2HXKHa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 06:07:30 -0400
Received: by obbuo13 with SMTP id uo13so3802175obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 03:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345791322.4503.0.camel@jlt3.sipsolutions.net>
References: <1345778993-23033-1-git-send-email-yeohchunyeow@gmail.com>
	<1345791322.4503.0.camel@jlt3.sipsolutions.net>
Date: Fri, 24 Aug 2012 18:07:29 +0800
Message-ID: <CAEFj985DUnjrLG5xoJxrmxF7Geueh7uJkaN+fz1KjtV_3VPAaA@mail.gmail.com> (sfid-20120824_120735_255206_0BFF0F6B)
Subject: Re: [PATCH] ath5k: set hw mfp capable flag for secured mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> You shouldn't blindly set the flag though because it "is required". You
> really need to test that management frames aren't decrypted by the
> hardware erroneously.

Noted. Will take a look on alternative solution for this.

--
Chun-Yeow
